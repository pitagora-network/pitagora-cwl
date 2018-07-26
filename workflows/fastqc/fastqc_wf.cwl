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
  fastqc_summary:
    type: File[]
    outputSource: fastqc-util/fastqc_summary

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
  fastqc-util-tsv:
    run: fastqc-util-tsv.cwl
    in:
      fastqcResults: fastqc/fastqc_result
    out:
      [fastqc_summary_tsv]
  fastqc-util-ttl:
    run: fastqc-util-ttl.cwl
    in:
      fastqcResults: fastqc/fastqc_result
    out:
      [fastqc_summary_ttl]
