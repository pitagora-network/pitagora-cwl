# STAR-rsem workflow

*STAR-rsem workflow is now under heavy development*

## Test

Single-end input version:

```
$ curl https://raw.githubusercontent.com/pitagora-galaxy/cwl/master/test/bin/run-cwl | bash -s "star-rsem_wf_se"
```

Paired-end input version:

```
$ curl https://raw.githubusercontent.com/pitagora-galaxy/cwl/master/test/bin/run-cwl | bash -s "star-rsem_wf_pe"
```

### Steps

1. [download-sra](/tools/download-sra)
2. [pfastq-dump](/tools/pfastq-dump)
3. [star-mapping](/tools/star/mapping)
4. [samtools_sam2bam](/tools/samtools/sam2bam)
5. [samtools_sort](/tools/samtools/sort)
6. [rsem_calculate-expression](/tools/rsem/calculate-expression)
