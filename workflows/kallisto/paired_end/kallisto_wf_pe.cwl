cwlVersion: v1.0
class: Workflow

inputs:
  ## Common inputs
  # Required
  nthreads: int

  ## Inputs for download-sra
  # Required
  run_ids: string[]
  # Optional
  repo: string?

  ## Inputs for pfastq-dump
  #   None

  ## Inputs for kallisto quant
  # Required
  index_file: File
  out_dir_name: string?
  # Optional
  boostrap_samples: int?

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
    run: kallisto_quant.cwl
    in:
      index_file: index_file
      out_dir_name: out_dir_name
      boostrap_samples: boostrap_samples
      fq: pfastq_dump/fastqFiles
    out:
      [quant_output]
