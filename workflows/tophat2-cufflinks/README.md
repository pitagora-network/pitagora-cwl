# tophat2-cufflinks workflow

## Workflow steps

1. [download-sra](/tools/download-sra)
2. [pfastq-dump](/tools/pfastq-dump)
3. [tophat2-mapping](/tools/tophat2/mapping)
4. [cufflinks](/tools/cufflinks)

## Run workflow

### Preparation: Collect required CWL definition files

You need to place the dependent tool definition files in the same directory of the workflow definition file. Use the bundled shell script to copy the tool files for workflow steps.

```
$ cd /path/to/pitagora-cwl
$ sh ./test/bin/collect-steps.sh
```

This will copy the CWL tool definition files in `tools` directory to the directories of workflow definitions. This will copy the files for all the pitagora-cwl workflows, so you do not have to run for each workflow.

### Run by cwltool

You can use any [CWL implementation](https://www.commonwl.org/#Implementations) to run the CWL workflow. Below is the example command line to run the workflow by [cwltool](https://github.com/common-workflow-language/cwltool/), the reference implementation of CWL runner.

For single-end reads:

```
$ cwltool single_end/tophat2-cufflinks_wf_se.cwl [-h] --annotation ANNOTATION --genome_index_base GENOME_INDEX_BASE --genome_index_dir GENOME_INDEX_DIR --nthreads NTHREADS [--repo REPO] --run_ids RUN_IDS
```

For paired-end reads:

```
$ cwltool paired_end/tophat2-cufflinks_wf_pe.cwl [-h] --annotation ANNOTATION --genome_index_base GENOME_INDEX_BASE --genome_index_dir GENOME_INDEX_DIR --nthreads NTHREADS [--repo REPO] --run_ids RUN_IDS
```

## Test

The test script is bundled in this repository. It requires you to install `cwltool` beforehand, and will download the reference data from AWS S3 and get sequence data from Sequence Read Archive to run the workflow.

Running the test script will download [bowtie2 index for GRCh38](https://s3.amazonaws.com/nig-reference/GRCh38/bowtie2_index/bowtie2_GRCh38.tar.gz) (4.4GB, md5: f4dba37e62a6cf2936c1cc0140a69c39) and [Gencode gene annotation file](https://s3.amazonaws.com/nig-reference/GRCh38/gencode_v28_annotation/gencode.v28.annotation.gtf.gz) (38MB, md5: 0c64fd0ab90aef446119d113ca62252f).

If you already cloned this repository, run `run-cwl` command in `test/bin` with the path to the repo and workflow name as below:

Single-end input version:

```
$ cd /path/to/pitagora-cwl
$ ./test/bin/run-cwl --cwl-repo . "tophat2-cufflinks_wf_se"
```

Paired-end input version:

```
$ cd /path/to/pitagora-cwl
$ ./test/bin/run-cwl --cwl-repo . "tophat2-cufflinks_wf_pe"
```

Or simply use curl command which clones this repository to `$HOME/.pitagora-cwl` and run the workflow.

Single-end input version:

```
$ curl https://raw.githubusercontent.com/pitagora-network/pitagora-cwl/master/test/bin/run-cwl | bash -s "tophat2-cufflinks_wf_se"
```

Paired-end input version:

```
$ curl https://raw.githubusercontent.com/pitagora-network/pitagora-cwl/master/test/bin/run-cwl | bash -s "tophat2-cufflinks_wf_pe"
```
