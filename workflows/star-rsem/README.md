# STAR-rsem workflow

## Preparation: Collect required CWL definition files

You need to place the dependent tool definition files in the same directory of the workflow definition file. Use the bundled shell script to copy the tool files for workflow steps.

```
cd /path/to/pitagora-cwl
sh ./test/bin/collect-steps.sh
```

This will copy the CWL tool definition files in `tools` directory to the directories of workflow definitions. This will copy the files for all the pitagora-cwl workflows, so you do not have to run for each workflow.

## Test

*Note: current STAR-RSEM workflow test scripts occurs STAR's permanentFailure: too many levels of symbolic links, will find a way to fix it*

### Steps

1. [download-sra](/tools/download-sra)
2. [pfastq-dump](/tools/pfastq-dump)
3. [star-mapping](/tools/star/mapping)
4. [samtools_sam2bam](/tools/samtools/sam2bam)
5. [samtools_sort](/tools/samtools/sort)
6. [rsem_calculate-expression](/tools/rsem/calculate-expression)
