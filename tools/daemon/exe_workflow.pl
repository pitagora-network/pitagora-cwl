#!/usr/bin/perl -w

require "Util.pm";

#*********************************************************************
# Name   -- exe_workflow.pl
# Date   -- 6.Mar.2018
#*********************************************************************

main();

sub main {

    my $runIdList = $ARGV[0];
    my $resultDir = $ARGV[1];
    my $cwlProgramFile = $ARGV[2];
    my $ymlTemplateFile = $ARGV[3];
    my $programName = $ARGV[4];

    ### bucket name for results.
    my $resBucketName = "ngs-workflow-result";

    ### stderr.log
    my $stderrLog = "stderr.log";

    if (scalar(@ARGV) != 5) {
        die "Usage: perl ExeRnaseqMutationCwlWorkflow.pl run_id_list result_directory cwl_program_file yaml_template_file program_name\n";
    }

    ### get fastq data.
    my %runIdList; # key: Sample ID base (e.g. SRR2046936)
    getRunId($runIdList, \%runIdList);

    foreach my $sampleBaseId (sort {$runIdList{$a} cmp $runIdList{$b}} keys %runIdList) {
        if (!-e "$resultDir/$sampleBaseId") {
            mkdir("$resultDir/$sampleBaseId");
            system("chmod 777 $resultDir/$sampleBaseId");
        }
        ### move result directory.
        chdir("$resultDir/$sampleBaseId");

        ### make program name file.
        system("echo $programName > $resultDir/$sampleBaseId/program_name");

        ### start time.
        system("date +\"%Y-%m-%d %H:%M:%S\"> start");
        ### generate a yml file using a yml template file.
        system("sed -e \"s|RUN_ID|$runIdList{$sampleBaseId}|g\" -e \"s|/path/to/fastq|$resultDir/$sampleBaseId|g\" -e \"s|FASTQID|$sampleBaseId|g\" $ymlTemplateFile > $sampleBaseId.yml");

        ### execute cwltool
        system("cwltool --debug --leave-container --compute-checksum --outdir $resultDir/$sampleBaseId $cwlProgramFile $resultDir/$sampleBaseId/$sampleBaseId.yml 2> $resultDir/$sampleBaseId/$stderrLog; echo $? 1>> $resultDir/$sampleBaseId/$stderrLog");
        ### end time.
        system("date +\"%Y-%m-%d %H:%M:%S\" > end");

        ### execute docker ps -a
        system("docker ps -a --no-trunc > $sampleBaseId.dockerpslog");

        ### get container information
        my @containerInfo; #"short container ID":"image name":"command":"names"
        getContainerInfo("$sampleBaseId.dockerpslog", \@containerInfo);

        ### get container full ID
        if (!open(CINFO, ">containerList")) {
            die "File open failed: >containerList\n";
        }
        my @scids;
        foreach my $containerLine (@containerInfo) {
            my $shortCid = substr($containerLine, 0, 12);
            push @scids, $shortCid;
            my $fullCid = `docker inspect --format="{{.Id}}" $shortCid`;
            chomp($fullCid);
            print CINFO $fullCid.":".$containerLine."\n";
        }
        close(CINFO);

        ### delete docker containers.
        foreach my $cid (@scids) {
            system("docker stop $cid");
            system("docker rm $cid");
        }
        undef @scids;

        system("rm -r /tmp/tmp*");

        ############# for s3
        ### get date and time
        my $date = "";
        my $time = "";
        getDateTime(\$date, \$time);
        ### change directory.
        chdir("$resultDir");
        ### upload workflow results to AWS s3.
        # delete BAM, SAM, and FASTQ files (and other subdirectries).
        delete_files_from_results("$resultDir/$sampleBaseId");
        # tar and gzip.
        my $tarFile = "$resultDir/".$sampleBaseId.".tar.gz";
        system("tar cvfz $tarFile $resultDir/$sampleBaseId");
        my $resPrefix = $programName."/".$date."-".$time;
        create_s3bucket_prefix($resBucketName, $resPrefix);
        if (-e "$resultDir/$sampleBaseId/error") {
            my $trimTarFile = $tarFile;
            $trimTarFile =~ s/\.tar\.gz/-error\.tar\.gz/g;
            system("mv $tarFile $trimTarFile");
            $tarFile = $trimTarFile;
        }
        cp_json_log_to_s3bucket($tarFile, $resBucketName, $resPrefix);
    }
}


