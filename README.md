# Pitagora Workflows in CWL

[![DOI](https://zenodo.org/badge/172622089.svg)](https://zenodo.org/badge/latestdoi/172622089)

This repository is to share the [Common Workflow Language](https://www.commonwl.org) definition files of tools and workflows, maintained by Pitagora Network, as known as Galaxy Community Japan.

## Tools

- Get Data
  - [download-sra](tools/download-sra)
  - [fastq-dump](tools/fastq-dump)
  - [pfastq-dump](tools/pfastq-dump)
- Data Formatting
  - [samtools](tools/samtools)
- Read Alignment
  - [bwa](tools/bwa)
  - [bowtie](tools/bowtie)
  - [bowtie2](tools/bowtie2)
  - [last](tools/last)
  - [star](tools/star)
  - [HISAT2](tools/hisat2)
- Variant Analysis
  - [gatk](tools/gatk)
  - [annovar](tools/annovar)
  - [picard](tools/picard)
- Transcriptome Analysis
  - splice junction mapper
    - [tophat2](tools/tophat2)
  - transcript assemble / quantification
    - [cufflinks](tools/cufflinks)
    - [stringtie](tools/stringtie)
    - [eXpress](tools/eXpress)
    - [rsem](tools/rsem)
    - [rsubread](tools/rsubread)
    - [kallisto](tools/kallisto)
    - [sailfish](tools/sailfish)
    - [salmon](tools/salmon)
  - de novo transcriptome assemble
    - [trinity](tools/trinity)

## Workflows

See documentation in each workflow directory for the instruction.

- RNA-Seq
  - TopHat2-*
    - [tophat2-cufflinks](workflows/tophat2-cufflinks)
  - HISAT2-*
    - [hisat2-cufflinks](workflows/hisat2-cufflinks)
    - [hisat2-stringtie](workflows/hisat2-stringtie)
  - STAR-*
    - [star-cufflinks](workflows/star-cufflinks)
    - [star-stringtie](workflows/star-stringtie)
  - [kallisto](workflows/kallisto)
  - [salmon](workflows/salmon)

## Test

Each workflow listed above has a shell script to run the workflow for testing. See README in each workflow directory for how to exec the test run.

The test scripts bundled with the workflows will automatically download the corresponding reference data listed below.

- [Gencode gene annotation GRCh38](test/reference/annotation/gencode/GRCh38)
- [Bowtie2 index file GRCh38](test/reference/bowtie2_index/GRCh38/)
- [HiSAT2 index file GRCh38](test/reference/hisat2_index/GRCh38)
- [Kallisto index file GRCh38](test/reference/kallisto_index/GRCh38)
- [Salmon index file GRCh38](test/reference/salmon_index/GRCh38)
- [STAR index file GRCh38](test/reference/star_index/GRCh38)