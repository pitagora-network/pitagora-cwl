#!/usr/bin/perl

#*************************************************************************
# Name   -- Util.pm
# Date   -- 21.July.2016
# Update -- 24.Dec.2017
#        -- 11.Jan.2018 added AWS S3 CLI manipulation subroutines.
#*************************************************************************

sub getDateTime {

    my $dateRef = $_[0]; # scalar reference.
    my $timeRef = $_[1]; # scalar reference.

    my $time = time();

    my $sec = (localtime($time))[0];
    my $min = (localtime($time))[1];
    my $hour = (localtime($time))[2];
    my $mday = (localtime($time))[3];
    my $month = (localtime($time))[4];
    my $year = (localtime($time))[5];

    $$timeRef = $hour."-".$min."-".$sec;
    $$dateRef = ($year + 1900)."-".sprintf("%02d", $month + 1)."-".sprintf("%02d", $mday);

}


sub getFastqData {

    my $fastqDir = $_[0];
    my $fastqDataListRef = $_[1];

    if (!opendir(FASTQDIR, "$fastqDir")) {
        die "Directory open failed: $fastqDir\n";
    }
    while (my $fastq = readdir FASTQDIR) {
        if ($fastq !~ /\.f.*q$/) {
            next;
        }
        my $baseName = $fastq;
        if ($fastqDir =~ /pair$/) {
            $baseName =~ s/(_\d)*\.f.*q$//g;
            if (!exists(${$fastqDataListRef}{$baseName})) {
                ${$fastqDataListRef}{$baseName} = "$fastqDir/$fastq";
            } else {
                ${$fastqDataListRef}{$baseName} .= ","."$fastqDir/$fastq";
            }
        } else {
            $baseName =~ s/\.f.*q$//g;
            ${$fastqDataListRef}{$baseName} = "$fastqDir/$fastq";
        }
    }
    closedir(FASTQDIR);

}


sub getRunId {

    my $runIdList = $_[0];
    my $runIdListRef = $_[1];

    if (!open(RUNID, "$runIdList")) {
        die "File open failed: $runIdList\n";
    }
    while (my $dataLine = <RUNID>) {
        chomp($dataLine);
        my @dataInfo = split(",", $dataLine);
        my $baseName = $dataInfo[0];
        ${$runIdListRef}{$baseName} = $dataLine;
    }
    close(RUNID);

}


sub create_s3bucket_prefix {

    my $bucketName = $_[0];
    my $prefix = $_[1];

    my $output = `aws s3api list-objects --bucket $bucketName --prefix $prefix`;
    chomp($output);

    if (length($output) == 0) {
        system("aws s3api put-object --bucket $bucketName --key \"$prefix/\"");
    }

}


sub cp_json_log_to_s3bucket {

    my $jsonLogFile = $_[0];
    my $bucketName = $_[1];
    my $prefix = $_[2];

    system("aws s3 cp $jsonLogFile s3://$bucketName/$prefix/");

}


sub getContainerInfo {

    my $logFile = $_[0];
    my $containerInfoRef = $_[1]; # array reference.

    if (!open(LOG, "$logFile")) {
        die "File open failed: $logFile\n";
    }
    while (my $dataLine = <LOG>) {
        chomp($dataLine);
        if ($dataLine =~ /^CONTAINER ID/) {
            next;
        }
#        if ($dataLine !~ /Exited \(0\)/) {
#            next;
#        }
#        if ($dataLine =~ /rancher/) {
#            next;
#        }
        push @$containerInfoRef, $dataLine;
    }
    close(LOG);

}


sub makeContainerInfoList {

    my $containerList = $_[0];
    my $containerInfoRef = $_[1];

    ### get container full ID
    if (!open(CINFO, ">containerList")) {
        die "File open failed: >containerList\n";
    }
    my @scids;
    foreach my $containerLine (@$containerInfoRef) {
        my $shortCid = substr($containerLine, 0, 12);
        push @scids, $shortCid;
        my $fullCid = `docker inspect --format="{{.Id}}" $shortCid`;
        chomp($fullCid);
        print CINFO $fullCid.":".$containerLine."\n";
    }
    close(CINFO);

}


sub delete_files_from_results {

    my $resultDir = $_[0];

    if (!opendir(RESULTDIR, "$resultDir")) {
        die "Directory open failed: $resultDir\n";
    }
    while (my $file = readdir RESULTDIR) {
        # delete FASTQ files.
        if ($file =~ /\.fq$|\.fastq$/) {
            unlink("$resultDir/$file");
            next;
        }
        # delete SAM files.
        if ($file =~ /\.sam$/) {
            unlink("$resultDir/$file");
            next;
        }
        # delete BAM files.
        if ($file =~ /\.bam$|\.bai$|\.sort$/) {
            unlink("$resultDir/$file");
            next;
        }
        # for sailfish and salmon.
        if ($file eq "sailfish_quant" || $file eq "salmon_quant") {
            system("cp $resultDir/$file/quant.sf $resultDir/.");
            system("rm -r $resultDir/$file");
        }
    }
    closedir(RESULTDIR);

}


sub kill_killer_job_prg {

    my @psLines = `ps aux | grep kill_job.pl`;

    foreach my $ps (@psLines) {
        if ($ps =~ /grep/) {
            next;
        }
        if ($ps =~ /perl/) {
            my @dataInfo = split(" ", $ps);
            system("kill -9 $dataInfo[1]");
        }
    }

}


1;

