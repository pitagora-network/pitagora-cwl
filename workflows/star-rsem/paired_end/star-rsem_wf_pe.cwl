cwlVersion: v1.0
class: Workflow

inputs:
  ## Common input
  nthreads: int

  ## Inputs for download_sra
  repo: string?
  run_ids: string[]

  ## Inputs for star_mapping
  genomeDir: Directory

  ## Inputs for rsem
  rsem_index_dir: Directory
  rsem_index_prefix: string
  rsem_output_prefix: string

outputs:
  genes_result:
    type: File
    outputSource: rsem-calculate-expression/genes_result
  isoforms_result:
    type: File
    outputSource: rsem-calculate-expression/isoforms_result
  stat:
    type: File
    outputSource: rsem-calculate-expression/stat

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
      sraFiles: download_sra/sraFiles
      nthreads: nthreads
    out:
      [forward, reverse]

  star_mapping:
    run: star_mapping.cwl
    in:
      nthreads: nthreads
      genomeDir: genomeDir
      readFilesIn: [pfastq-dump/forward, pfastq-dump/reverse]
    out:
      [output_bam]

  samtools_sort:
    run: samtools_sort.cwl
    in:
      input_bam: star_mapping/output_bam
      nthreads: nthreads
    out: [sorted_bamfile]

  rsem-calculate-expression:
    run: rsem-calculate-expression.cwl
    in:
      input_bam: samtools_sort/sorted_bamfile
      rsem_index_dir: rsem_index_dir
      rsem_index_prefix: rsem_index_prefix
      rsem_output_prefix: rsem_output_prefix
    out: [genes_result, isoforms_result, stat]
