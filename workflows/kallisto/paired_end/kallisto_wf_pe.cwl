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
      [forward, reverse]
  kallisto_quant:
    run: kallisto_quant_pe.cwl
    in:
      index_file: index_file
      out_dir_name: out_dir_name
      bootstrap_samples: bootstrap_samples
      fq1: pfastq_dump/forward
      fq2: pfastq_dump/reverse
    out:
      [quant_output]
