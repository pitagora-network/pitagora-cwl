#!/usr/bin/perl

use POSIX ();
use File::Basename;

#*********************************************************************
# Name   -- init.pl
#*********************************************************************

my $pidFile = "/tmp/cwllog_pid";
my $dmcDir = "";
my $esHost = "";
my $esPort = "";

main();

sub setting {

    my $home = $ENV{"HOME"};

    if (!open(CONFIG, "$home/.cwlmetrics/config")) {
        die "File open failed: ~/.cwlmetrics/config\n";
    }
    while (my $dataLine = <CONFIG>) {
        chomp($dataLine);
        if ($dataLine =~ /^ES_HOST/) {
            my @dataInfo = split("=", $dataLine);
            $dataInfo[1] =~ s/ //g;
            $esHost = $dataInfo[1];
            next;
        }
        if ($dataLine =~ /^ES_PORT/) {
            my @dataInfo = split("=", $dataLine);
            $dataInfo[1] =~ s/ //g;
            $esPort = $dataInfo[1];
            next;
        }
        if ($dataLine =~ /^DMC_DIR_PATH/) {
            my @dataInfo = split("=", $dataLine);
            $dataInfo[1] =~ s/ //g;
            $dmcDir = $dataInfo[1];
            next;
        }
    }
    close(CONFIG);

}


sub daemonize {

    ### first fork.
    my $pid = fork();
    if ($pid < 0) {
        exit(-1)
    }
    if ($pid > 0) {
        exit(0);
    }
    chdir("/");
    POSIX::umask(0) || die "Could not decouple from parent environment\n";
    POSIX::setsid() || die "Could not decouple from parent environment\n";

    ### second fork.
    $pid = fork();
    if ($pid < 0) {
        exit(-1); 
    }
    if ($pid > 0) {
        exit(0);
    }
    my $oldStderr = select(STDERR);
    $| = 1;
    select($oldStderr);
    my $oldStdout = select(STDOUT);
    $| = 1;
    select($oldStdout);
    $pid = $$;
    system("echo $pid > $pidFile");
    foreach (0 .. (POSIX::sysconf (&POSIX::_SC_OPEN_MAX) || 1024)) {
        POSIX::close $_
    }
    open(STDIN, "</dev/null");
    open(STDOUT, ">/dev/null");
    open(STDERR, ">/dev/null");
}



sub start {

    if (!open(PID, "$pidFile")) {
        $gPid = "";
    } else {
        print "$pidFile file already exists. Please check whether this daemon is running or not.\n";
        exit(-1);
        close(PID);
    }
    daemonize();
    run();
}


sub stop {

    if (!open(PID, "$pidFile")) {
        print "$pidFile does't exist. Please check whether this daemon is running or not.\n";
    }
    my $pid = <PID>;
    chomp($pid);
    close(PID);

    while (1) {
        my $pCount = kill "HUP", $pid;
        sleep(1);
        if ($pCount == 1) {
            last;
        } elsif ($pCount == 0) {
            print "No such process $pid\n";
            if (-e $pidFile) {
                unlink("$pidFile");
            }
        } else {}
    }
    setting();
    chdir("$dmcDir");
    system("docker-compose down");
    unlink("$pidFile"); # delete the /tmp/cwllog_pid file.

}


sub restart {
    stop();
    start();
}


sub run {

    my %pids = ();
    my %resDirPath = ();
    my %yamlPath = ();
    my %stderrLogPath = ();
    my %pidResDirPath = ();
    my %workflowName = ();

    # read .cwlmetrics/config file.
    setting();
    # start docker-compose for docker-metrics-collector.
    if ($dmcDir eq "") {
        die "docker-compose.yaml path must be set in the ~/.cwlmetrics/config file.\n";
    }
    if ($esHost ne "" && $esPort ne "") {
        system("export ES_HOST=$esHost");
        system("export ES_PORT=$esPort");
        chdir("$dmcDir");
        system("docker-compose up telegraf &");
    } else {
        chdir("$dmcDir");
        system("docker-compose up &");
    }
    chdir("-");
    while (1) {
        get_cwltool_exec_process(\%pids, \%resDirPath, \%yamlPath, \%stderrLogPath, \%pidResDirPath, \%workflowName);
        foreach my $pid (keys %pids) {
            my $noPid = exist_pid($pid);
            if ($noPid == 1) {
                my $resDir = $resDirPath{$pid};
                ### docker info.
                my $dockerInfo = "$resDir/docker_info";
                system("docker info > $dockerInfo");
                ### get cwl-related container ids.
                undef @cids;
                get_cid_lists_from_cidfiles($resDir, \@cids);
                ### docker ps.
                my $cidLine = "";
                foreach my $cid (@cids) {
                    if ($cidLine eq "") {
                        $cidLine = "-f id=$cid";
                    } else {
                        $cidLine .= " -f id=$cid";
                    }
                }
                my $dockerPs = "$resDir/docker_ps";
                system("docker ps -a --no-trunc $cidLine > $dockerPs");
                ### delete docker containers;
                foreach $cid (@cids) {
                    system("docker rm $cid");
                }
                ### docker-cwllog-generator
                exec_cwl_json_log_generator($resDir, $dockerPs, $dockerInfo, $yamlPath{$pid}, $stderrLogPath{$pid});
                ### insert workflow metrics into ES.
                my $cwlLog = $resDir."/cwl_log.json";
                send_logs_to_es($cwlLog);
                delete $pids{$pid};
                delete $resDirPath{$pid};
                delete $yamlPath{$pid};
                delete $stderrLogPath{$pid};
                unlink($pidResDirPath{$pid});
                delete $pidResDirPath{$pid};
                delete $workflowName{$pid};
            }
        }
        sleep(5);
    }

}


sub get_cwltool_exec_process {

    my $pidsRef = $_[0]; # hash reference.
    my $resDirPathRef = $_[1]; # hash reference.
    my $yamlPathRef = $_[2]; # hash reference.
    my $stderrLogPathRef = $_[3]; # hash reference.
    my $pidResDirPathRef = $_[4]; # hash reference.
    my $workflowNameRef = $_[5]; # hash reference.

    ### check cwltool commands.
    my $ps = `ps aux | grep cwltool`;
    chomp($ps);
    my @psLines = split("\n", $ps);
    my $pid = "";
    foreach my $line (@psLines) {
        if ($line =~ /\.cwl/ && $line =~ /python/) {
            my @dataInfo = split(" ", $line);
            $pid = $dataInfo[1];
            my $dirHit = 0;
            if (!exists(${$pidsRef}{$pid})) {
                ${$pidsRef}{$pid} = "start";
                my $command = "";
                my $resDir = "";
                foreach my $data (@dataInfo) {
                    if ($data =~ /\.cwl/) {
                        my $workflow = basename($data);
                        my @nameInfo = split(/\./, $workflow);
                        ${$workflowNameRef}{$pid} = $nameInfo[0];
                        $command = $data;
                        next;
                    }
                    if ($data =~ /\.yaml|\.yml|\.json/i) {
                        $command .= " ".$data;
                        next;
                    }
                    if ($data eq "--outdir") {
                        $dirHit = 1;
                        next;
                    }
                    if ($dirHit == 1) { # $data : directory path.
                        ${$resDirPathRef}{$pid} = $data;
                        $resDir = $data;
                    }
                }
                my $contents = $pid."	".$resDir."	".$command;
                my $pidResDirFile = "/tmp/cwl_";
                $pidResDirFile .= $pid;
                system("echo '$contents' > $pidResDirFile");
                ${$pidResDirPathRef}{$pid} = $pidResDirFile;
                ### get the yaml/json file path. 
                my $yamlJsonPath = get_yaml_json_file_path($pidResDirFile);
                ${$yamlPathRef}{$pid} = $yamlJsonPath;
                ### get the stderr log file path.
                my $stderrLog = get_stderr_file_path($pid);
                ${$stderrLogPathRef}{$pid} = $stderrLog;
            }
        }
    }

}


sub exist_pid {

    my $pid = $_[0];

    my $output = `ps ho pid p $pid > /dev/null`;
    my $status = $? >> 8;

    return $status;

}


sub get_cid_lists_from_cidfiles {

    my $resDir = $_[0];
    my $cidsRef = $_[1]; # array reference.

    if (!opendir(RESDIR, "$resDir")) {
        die "Directory open failed: $resDir\n";
    }
    while (my $resFile = readdir RESDIR) {
        chomp($resFile);
        if ($resFile !~ /\.cid$/) {
            next;
        }
        my $cid = `cat $resDir/$resFile`;
        push @$cidsRef, $cid;
        unlink("$resDir/$resFile");
    }
    closedir(RESDIR);

}


sub get_yaml_json_file_path {
 
    my $pidResDirFile = $_[0];

    if (!open(PIDFILE, "$pidResDirFile")) {
        die "File open failed: $pidResDirFile\n";
    }
    my $pidLine = <PIDFILE>;
    close(PIDFILE);
    chomp($pidLine);
    my @pidInfo = split("	", $pidLine);
    my $pid = $pidInfo[0];
    my @commands = split(" ", $pidInfo[2]); 
    my $yamlDir = dirname($commands[1]);
    my $yamlName = basename($commands[1]);

    if ($yamlDir =~ /^\//) {
        return $commands[1];
    } else {
        if (-e "/proc") { # for linux.
            my $cwd = `ls -l /proc/$pid/cwd`;
            chomp($cwd);
            my @pathInfo = split(" ", $cwd);
            my $currentDir = pop @pathInfo;
            return $currentDir."/".$yamlDir."/".$yamlName;
        } else { # for mac.
            my $cwd = `lsof -p $pid`;
            chomp($cwd);
            my @pathInfo = split("\n", $cwd);
            my $currentDir = "";
            foreach my $path (@pathInfo) {
                my @data = split(" ", $path);
                if ($data[3] eq "cwd") {
                    $currentDir = pop @data;
                    last;
                }
            }
            return $currentDir."/".$yamlDir."/".$yamlName;
        }
    }

}


sub get_stderr_file_path {

    my $pid = $_[0];

    if (-e "/proc") { # for linux.
        my $stderr = `ls -l /proc/$pid/fd/2`;
        chomp($stderr);
        my @pathInfo = split(" ", $stderr);
        my $stderrLog = pop @pathInfo;
        return $stderrLog;
    } else { # for mac.
        my $cwd = `lsof -p $pid`;
        chomp($cwd);
        my @pathInfo = split("\n", $cwd);
        my $stderrLog = "";
        foreach my $path (@pathInfo) {
            my @data = split(" ", $path);
            if ($data[3] eq "2w") {
                $stderrLog = pop @data;
                last;
            }
        }
        return $stderrLog;
    }

}


sub exec_cwl_json_log_generator {

    my $resDir = $_[0];
    my $dockerPs = $_[1];
    my $dockerInfo = $_[2];
    my $yamlJsonPath = $_[3];
    my $cwlLog = $_[4];

    my $dockerPsName = basename($dockerPs);
    my $dockerPsDir = dirname($dockerPs);

    my $dockerInfoName = basename($dockerInfo);
    my $dockerInfoDir = dirname($dockerInfo);

    my $yamlJsonName = basename($yamlJsonPath);
    my $yamlJsonDir = dirname($yamlJsonPath);

    my $cwlName = basename($cwlLog);
    my $cwlDir = dirname($cwlLog);

    system("docker run --rm -v $cwlDir:/cwl/log -v $yamlJsonDir:/cwl/src -v $resDir:/cwl/result -v $dockerPsDir:/cwl/result -v $dockerInfoDir:/cwl/result yyabuki/docker-cwllog-generator cwl_log_generator.py --docker_ps /cwl/result/$dockerPsName --docker_info /cwl/result/$dockerInfoName --cwl_log /cwl/log/$cwlName --cwl_input /cwl/src/$yamlJsonName");

}


sub send_logs_to_es {

    my $cwlLog = $_[0];

    my $uuid = `uuidgen -t`;
    chomp($uuid);

    my $host = $esHost;
    my $port = $esPort;

    # default
    if ($host eq "") {
        $host = "localhost";
    }
    # default
    if ($port eq "") {
        $port = "9200";
    }
    my $command = "curl -H \"Content-Type: application/json\" -XPOST '$host:$port/workflow/workflow_log/".$uuid."?pretty' --data-binary \@".$cwlLog;
    system("$command"); 

}


sub main {

    my $status = $ARGV[0];

    if (scalar(@ARGV) != 1) {
        die "Usage: ./init.pl start|stop|restart\n";
    }

    if ($status eq "start") {
        start();
    } elsif ($status eq "stop") {
        stop();
    } elsif ($status eq "restart") {
        restart();
    } else {
        die "Usage: ./init.pl start|stop|restart\n";
    }

}
