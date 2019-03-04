# Salmon workflow

## Steps

1. [download-sra](/tools/download-sra)
2. [pfastq-dump](/tools/pfastq-dump)
3. [salmon-quant](/tools/salmon/quant)

## Run workflow

### Preparation: Collect required CWL definition files

You need to place the dependent tool definition files in the same directory of the workflow definition file. Use the bundled shell script to copy the tool files for workflow steps.

```
$ cd /path/to/pitagora-cwl
$ sh ./test/bin/collect-steps.sh
```

This will copy the CWL tool definition files in `tools` directory to the directories of workflow definitions. This will copy the files for all the pitagora-cwl workflows, so you do not have to run for each workflow.

## Run by cwltool

You can use any [CWL implementation](https://www.commonwl.org/#Implementations) to run the CWL workflow. Below is the example command line to run the workflow by [cwltool](https://github.com/common-workflow-language/cwltool/), the reference implementation of CWL runner.

For single-end reads:

```
$ cwltool single_end/salmon_wf_se.cwl [-h] [--gibbs_samples GIBBS_SAMPLES] --index_dir INDEX_DIR --nthreads NTHREADS [--num_bootstraps NUM_BOOTSTRAPS] [--repo REPO] --run_ids RUN_IDS
```

For paired-end reads:

```
$ cwltool paired_end/salmon_wf_pe.cwl [-h] [--gibbs_samples GIBBS_SAMPLES] --index_dir INDEX_DIR --nthreads NTHREADS [--num_bootstraps NUM_BOOTSTRAPS] [--repo REPO] --run_ids RUN_IDS
```

## Test

The test script is bundled in this repository. It requires you to install `cwltool` beforehand, and will download the reference data from AWS S3 and get sequence data from Sequence Read Archive to run the workflow.

Running the test script will download [Salmon index for GRCh38](https://s3.amazonaws.com/nig-reference/GRCh38/salmon_index/salmon_GRCh38.tar.gz) (2.8GB, md5: bb83cce6f7c3e81087057e631cadc684).

If you already cloned this repository, run `run-cwl` command in `test/bin` with the path to the repo and workflow name as below:

Single-end input version:

```
$ cd /path/to/pitagora-cwl
$ ./test/bin/run-cwl --cwl-repo . "salmon_wf_se"
```

Paired-end input version:

```
$ cd /path/to/pitagora-cwl
$ ./test/bin/run-cwl --cwl-repo . "salmon_wf_pe"
```

Or simply use curl command which clones this repository to `$HOME/.pitagora-cwl` and run the workflow.

Single-end input version:

```
$ curl https://raw.githubusercontent.com/pitagora-network/pitagora-cwl/master/test/bin/run-cwl | bash -s "salmon_wf_se"
```

Paired-end input version:

```
$ curl https://raw.githubusercontent.com/pitagora-network/pitagora-cwl/master/test/bin/run-cwl | bash -s "salmon_wf_pe"
```
