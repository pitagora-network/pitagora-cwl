# HISAT2-cufflinks workflow

## Test

Single-end input version:

```
$ curl https://raw.githubusercontent.com/pitagora-galaxy/cwl/master/test/bin/run-cwl | bash -s "hisat2-cufflinks_wf_se"
```

Paired-end input version:

```
$ curl https://raw.githubusercontent.com/pitagora-galaxy/cwl/master/test/bin/run-cwl | bash -s "hisat2-cufflinks_wf_pe"
```

### Steps

1. [download-sra](/tools/download_sra)
2. [pfastq-dump](/tools/pfastq-dump)
3. [hisat2-mapping](/tools/hisat2/mapping)
4. [samtools_sam2bam](/tools/samtools/sam2bam)
5. [samtools_sort](/tools/samtools/sort)
6. [cufflinks](/tools/cufflinks)
