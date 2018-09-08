cwlVersion: v1.0
class: Workflow

inputs:
  nthreads: int
  run_id: string
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
      run_ids: run_id
    out:
      [sraFiles]
  fasterq_dump:
    run: fasterq-dump.cwl
    in:
      sraFiles: download_sra/sraFiles
      nthreads: nthreads
    out:
      [fastqFiles]
