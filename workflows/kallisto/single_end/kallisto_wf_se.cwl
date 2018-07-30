cwlVersion: v1.0
class: Workflow

inputs:
  ## Common inputs
  nthreads: int

  ## Inputs for download-sra
  run_ids: string[]
  repo: string?

  ## Inputs for kallisto quant
  index_file: File
  out_dir_name: string?
  fragment_length: double?
  standard_deviation: double?
  bootstrap_samples: int?

outputs:
  quant_output:
    type: Directory
    outputSource: kallisto_quant/quant_output

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
  kallisto_quant:
    run: kallisto_quant_se.cwl
    in:
      index_file: index_file
      out_dir_name: out_dir_name
      fragment_length: fragment_length
      standard_deviation: standard_deviation
      bootstrap_samples: bootstrap_samples
      fq: pfastq_dump/fastqFiles
    out:
      [quant_output]
