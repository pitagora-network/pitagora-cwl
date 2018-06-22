# HISAT2-eXpress workflow

## Test

*Note: current hisat2-eXpress workflow test scripts occurs eXpress's permanentFailure: it may be due to the test data, will find better one to fix it*

### Steps

1. [download-sra](/tools/download-sra)
2. [pfastq-dump](/tools/pfastq-dump)
3. [hisat2-mapping](/tools/hisat2/mapping)
4. [samtools_sam2bam](/tools/samtools/sam2bam)
5. [samtools_sort](/tools/samtools/sort)
6. [eXpress](/tools/eXpress)
