# Gencode annotation data (GRCh38, v28)

Pitagora-CWL reference data for testing

## Used in

- [tophat2-cufflinks](/workflows/tophat2-cufflinks)
- [hisat2-cufflinks](/workflows/hisat2-cufflinks)
- [hisat2-stringtie](/workflows/hisat2-stringtie)
- [star-cufflinks](/workflows/star-cufflinks)
- [star-stringtie](/workflows/star-stringtie)

## Data availability

- location
  - Amazon S3
    - https://s3.amazonaws.com/nig-reference/GRCh38/gencode_v28_annotation/gencode.v28.annotation.gtf.gz
  - Zenodo
    - https://zenodo.org/record/2587202/files/gencode.v28.annotation.gtf.gz?download=1
- file size: 37MB
- md5: `0c64fd0ab90aef446119d113ca62252f`

## How to create

1. Download the [Comprehensive gene annotation](ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_28/gencode.v28.annotation.gtf.gz) GTF format file in [Gencode Human Release 28 (GRCh38.p12)](https://www.gencodegenes.org/human/release_28.html) from the Gencode FTP server.
2. `gunzip` to unarchive.

> It contains the comprehensive gene annotation on the reference chromosomes only
> This is the main annotation file for most users
