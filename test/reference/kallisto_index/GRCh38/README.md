# Kallisto index (GRCh38)

Pitagora-CWL reference data for testing

## Used in

- [kallisto](/workflows/kallisto)

## Data availability

- location
  - Amazon S3
    - https://s3.amazonaws.com/nig-reference/GRCh38/kallisto_index/kallisto_GRCh38_Gencode.gz
  - Zenodo
    - https://zenodo.org/record/2587202/files/Kallisto_GRCh38_Gencode.gz?download=1
- file size:
- md5: `9953fa039e2b3d07f76f54a1ad13be17`

## How to create

1. Download the [reference mRNA fasta file](http://hgdownload.cse.ucsc.edu/goldenPath/hg38/bigZips/refMrna.fa.gz) from UCSC Genome browser FTP site.
2. `gunzip` to unarchive.
2. Run `kallisto index` by the docker container `quay.io/biocontainers/kallisto:0.44.0--h7d86c95_2` and [kallisto-index.cwl](/tools/kallisto/index/kallisto_index.cwl) with default parameters as specified in the CWL definition (`-k 31 --make-unique`) giving the fasta file to `fasta_files`.
