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

  ## Inputs for sailfish quant
  # Required
  index_dir: Directory
  gibbs_samples: int?
  num_bootstrap: int?

outputs:
  quant_results:
    type: Directory
    outputSource: sailfish_quant/quant_results

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
  sailfish_quant:
    run: sailfish_quant_se.cwl
    in:
      index_dir: index_dir
      fq1: pfastq_dump/forward
      fq2: pfastq_dump/forward
      nthreads: nthreads
      gibbs_samples: gibbs_samples
      num_bootstraps: num_bootstraps
    out:
      [quant_results]
