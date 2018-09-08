cwlVersion: v1.0
class: Workflow

inputs:
  nthreads: int
  run_id: string
  repo: string?

outputs:
  fastqFiles:
    type: File[]
    outputSource: fasterq_dump/fastqFiles

steps:
  download_sra:
    run: download-sra-single.cwl
    in:
      repo: repo
      run_id: run_id
    out:
      [sraFile]
  fasterq_dump:
    run: fasterq-dump.cwl
    in:
      srafile: download_sra/sraFile
      nthreads: nthreads
    out:
      [fastqFiles]
