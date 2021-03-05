# Salmon index (GRCh38)

Pitagora-CWL reference data for testing

## Used in

- [salmon](/workflows/salmon)

## Data availability

- location
  - Amazon S3
    - https://s3.amazonaws.com/nig-reference/GRCh38/salmon_index/salmon_GRCh38.tar.gz
  - Zenodo
    - https://zenodo.org/record/2587202/files/salmon_GRCh38.tar.gz?download=1
- file size:
- md5: `bb83cce6f7c3e81087057e631cadc684`

## How to create

1. Download the [reference mRNA fasta file](http://hgdownload.cse.ucsc.edu/goldenPath/hg38/bigZips/refMrna.fa.gz) from UCSC Genome browser FTP site.
2. `gunzip` to unarchive the index file.
2. Run `salmon index` by the docker container `combinelab/salmon:0.10.2` and [salmon_index.cwl](/tools/salmon/index/salmon_index.cwl) with default parameters as specified in the CWL definition (`--kmerLen 31 --type quasi --sasamp 1`) giving index file to `transcript_fasta`.
