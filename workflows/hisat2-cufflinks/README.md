# HISAT2-cufflinks workflow

## Steps

1. [download-sra](/tools/download-sra)
2. [pfastq-dump](/tools/pfastq-dump)
3. [hisat2-mapping](/tools/hisat2/mapping)
4. [samtools_sam2bam](/tools/samtools/sam2bam)
5. [samtools_sort](/tools/samtools/sort)
6. [cufflinks](/tools/cufflinks)

## Run workflows

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
$ cwltool single_end/hisat2-cufflinks_wf_se.cwl --annotation ANNOTATION --hisat2_idx_basedir HISAT2_IDX_BASEDIR --hisat2_idx_basename HISAT2_IDX_BASENAME --nthreads NTHREADS [--repo REPO] --run_ids RUN_IDS
```

For paired-end reads:

```
$ cwltool paired_end/hisat2-cufflinks_wf_pe.cwl --annotation ANNOTATION --hisat2_idx_basedir HISAT2_IDX_BASEDIR --hisat2_idx_basename HISAT2_IDX_BASENAME --nthreads NTHREADS [--repo REPO] --run_ids RUN_IDS
```

## Test

The test script is bundled in this repository. It requires you to install `cwltool` beforehand, and will download the reference data from AWS S3 and get sequence data from Sequence Read Archive to run the workflow.

Running the test script will download [HiSAT2 index for GRCh38](https://s3.amazonaws.com/nig-reference/GRCh38/hisat2_index/hisat2_GRCh38.tar.gz) (4.1GB, md5: 4ef5f64f419863c19a9142f94ea52e78) and [Gencode gene annotation file](https://s3.amazonaws.com/nig-reference/GRCh38/gencode_v28_annotation/gencode.v28.annotation.gtf.gz) (38MB, md5: 0c64fd0ab90aef446119d113ca62252f).

If you already cloned this repository, run `run-cwl` command in `test/bin` with the path to the repo and workflow name as below:

Single-end input version:

```
$ cd /path/to/pitagora-cwl
$ ./test/bin/run-cwl --cwl-repo . "hisat2-cufflinks_wf_se"
```

Paired-end input version:

```
$ cd /path/to/pitagora-cwl
$ ./test/bin/run-cwl --cwl-repo . "hisat2-cufflinks_wf_pe"
```

Or simply use curl command which clones this repository to `$HOME/.pitagora-cwl` and run the workflow.

Single-end input version:

```
$ curl https://raw.githubusercontent.com/pitagora-network/pitagora-cwl/master/test/bin/run-cwl | bash -s "hisat2-cufflinks_wf_se"
```

Paired-end input version:

```
$ curl https://raw.githubusercontent.com/pitagora-network/pitagora-cwl/master/test/bin/run-cwl | bash -s "hisat2-cufflinks_wf_pe"
```
