# init.pl
init.pl is a daemon program for collecting container and workflow execution metrics using inutano/docker-metrics-collector and yyabuki/docker-cwllog-metrics containers, respectively. Please check below sites for further information.

inutano/docker-metrics-collector: https://github.com/inutano/docker-metrics-collector

yyabuki/docker-cwllog-generator: https://hub.docker.com/r/yyabuki/docker-cwllog-generator/

# Prerequisite:
    1) Installs the docker-metrics-collector.
    % git clone https://github.com/inutano/docker-metrics-collector

    2) Prepares the ~/.cwlmetrics/config file.
    The config file contains three variables.
        ES_HOST=host name (e.g. ES_HOST=localhost)
        ES_PORT=port number (e.g. ES_PORT=9200)
        DMC_DIR_PATH= the directory path of the docker-metrics-collector.
        (e.g. DMC_DIR_PATH=/work/docker-metrics-collector)

# Command:
    % (perl) ./init.pl start|stop|restart

In order to collect the metrics using this daemon, workflow programs must be executed with seven arguments, and its standard error output needs to be redirected to a file.   
    --debug  
    --leave-container  
    --timestamps  
    --compute-checksum  
    --record-container-id  
    --cidfile-dir /path/to/container_id_dir  
    --outdir /path/to/cwl_result_dir  
    2> /path/to/file  
    e.g.  
    % cwltool --debug --leave-container --timestamps --compute-checksum --record-container-id --cidfile-dir /path/to/result --outdir /path/to/result Hisat2Workflow-se.cwl Hisat2Workflow-se-test.yml 2> /path/to/stderr.log
