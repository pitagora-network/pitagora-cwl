cwlVersion: v1.0
class: Workflow

inputs:
  nthreads: int
  run_ids: string[]
  repo: string?

outputs:
  fastqFiles:
    type: File[]
    outputSource: pfastq_dump/fastqFiles

steps:
  download_sra:
    run: download-sra.cwl
    in:
      repo: repo
      run_ids: run_ids
    out:
      [sraFiles]
  pfastq_dump:
    run: pfastq-dump.cwl
    in:
      sraFiles: download_sra/sraFiles
      nthreads: nthreads
    out:
      [fastqFiles]
