cwlVersion: v1.0
class: Workflow

inputs:
  ## Common input
  nthreads: int

  ## Inputs for download_sra
  repo: string?
  run_ids: string[]

  ## Inputs for fastq-dump
  gzip:
    type: boolean
    default: false

  ## Inputs for rsem
  rsem_index_dir: Directory
  rsem_index_prefix: string
  rsem_output_prefix: string

outputs:
  genes_result:
    type: File
    outputSource: star_rsem/genes_result
  isoforms_result:
    type: File
    outputSource: star_rsem/isoforms_result
  stat:
    type: Directory
    outputSource: star_rsem/stat
  star_output:
    type: Directory
    outputSource: star_rsem/star_output

steps:
  download-sra:
    run: download-sra.cwl
    in:
      repo: repo
      run_ids: run_ids
    out:
      [sraFiles]

  pfastq-dump:
    run: pfastq-dump.cwl
    in:
      sraFiles: download-sra/sraFiles
      nthreads: nthreads
      gzip: gzip
    out:
      [fastqFiles]

  star_rsem:
    run: rsem-calculate-expression_se.cwl
    in:
      nthreads: nthreads
      input_fastq: pfastq-dump/fastqFiles
      rsem_index_dir: rsem_index_dir
      rsem_index_prefix: rsem_index_prefix
      rsem_output_prefix: rsem_output_prefix
    out: [genes_result, isoforms_result, stat, star_output]
