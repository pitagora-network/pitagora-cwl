# Bowtie2 index (GRCh38)

Pitagora-CWL reference data for testing

## Used in

- [tophat2-cufflinks](/workflows/tophat2-cufflinks)

## Data availability

- location
  - Amazon S3
    - https://s3.amazonaws.com/nig-reference/GRCh38/bowtie2_index/bowtie2_GRCh38.tar.gz
  - Zenodo
    - https://zenodo.org/record/2587202/files/bowtie2_GRCh38.tar.gz?download=1
- file size: 4.4GB
- md5: `f4dba37e62a6cf2936c1cc0140a69c39`

## How to create

1. Download [bowtie2 index file for GRCh38](ftp://ftp.ncbi.nlm.nih.gov/genomes/archive/old_genbank/Eukaryotes/vertebrates_mammals/Homo_sapiens/GRCh38/seqs_for_alignment_pipelines/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.bowtie_index.tar.gz) from the link on [the official documentation page of bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml).
2. `gunzip` to unarchive.
