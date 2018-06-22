# STAR-rsem workflow

## Test

*Note: current STAR-RSEM workflow test scripts occurs STAR's permanentFailure: too many levels of symbolic links, will find a way to fix it*

### Steps

1. [download-sra](/tools/download-sra)
2. [pfastq-dump](/tools/pfastq-dump)
3. [star-mapping](/tools/star/mapping)
4. [samtools_sam2bam](/tools/samtools/sam2bam)
5. [samtools_sort](/tools/samtools/sort)
6. [rsem_calculate-expression](/tools/rsem/calculate-expression)
