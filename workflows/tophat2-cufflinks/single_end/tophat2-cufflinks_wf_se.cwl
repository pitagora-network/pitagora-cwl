cwlVersion: v1.0
class: Workflow

inputs:
  ## Common input
  nthreads: int

  ## Inputs for download-sra
  repo: string?
  run_ids: string[]

  ## Inputs for tophat2_mapping
  genome_index_dir: Directory
  genome_index_base: string

  ## Inputs for cufflinks
  annotation: File

outputs:
  cufflinks_result:
    type:
      type: array
      items: File
    outputSource: cufflinks/cufflinks_result

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
    out:
      [fastqFiles]

  tophat2_mapping:
    run: tophat2_mapping_se.cwl
    in:
      genome_index_dir: genome_index_dir
      genome_index_base: genome_index_base
      fq: pfastq-dump/fastqFiles
      nthreads: nthreads
    out:
      [accepted_hits_bam]

  cufflinks:
    run: cufflinks.cwl
    in:
      nthreads: nthreads
      annotation: annotation
      input_bam: tophat2_mapping/accepted_hits_bam
    out: [cufflinks_result]
