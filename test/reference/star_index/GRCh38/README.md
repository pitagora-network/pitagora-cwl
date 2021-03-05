# STAR index (GRCh38)

Pitagora-CWL reference data for testing

## Used in

- [star-cufflinks](/workflows/star-cufflinks)
- [star-stringtie](/workflows/star-stringtie)

## Data availability

- location
  - Amazon S3
    - https://s3.amazonaws.com/nig-reference/GRCh38/star_index/star_GRCh38.tar.gz
  - Zenodo
    - https://zenodo.org/record/2587202/files/star_GRCh38.tar.gz?download=1
- file size: 23.1GB
- md5: `3e185ac85ea5aa32550d455554f72453`

## How to create

1. Download [GRCh38 reference genome fasta file](http://hgdownload.cse.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz) from UCSC Genome browser FTP site.
2. Download [Comprehensive gene annotation](ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_28/gencode.v28.annotation.gtf.gz) GTF format file in [Gencode Human Release 28 (GRCh38.p12)](https://www.gencodegenes.org/human/release_28.html) from Gencode FTP server.
3. `gunzip` to unarchive genome fasta and annotation gtf.
3. Run `STAR --runMode genomeGenerate` with the docker container `quay.io/biocontainers/star:2.6.0c--0` and [star_index.cwl](/tools/star/index/star_index.cwl) with default parameters as specified in the CWL definition (`--sjdbOverhang 100`) giving reference genome fasta to `genomeFastaFiles` and annotation gtf to `sjdbGTFfile`.
