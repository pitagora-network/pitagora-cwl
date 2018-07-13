cwlVersion: v1.0
class: Workflow

inputs:
  nthreads: int
  run_ids: string[]
  repo: string?

outputs:
  fastqc_result:
    type: File[]
    outputSource: fastqc/fastqc_result

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
  fastqc:
    run: fastqc.cwl
    in:
      seqfile: pfastq_dump/fastqFiles
      nthreads: nthreads
    out:
      [fastqc_result]
