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
  gzip:
    type: boolean
    default: false

  ## Inputs for sailfish quant
  # Required
  index_dir: Directory
  gibbs_samples: int?
  num_bootstraps: int?

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
      gzip: gzip
    out:
      [fastqFiles]
  sailfish_quant:
    run: sailfish_quant_se.cwl
    in:
      index_dir: index_dir
      fq: pfastq_dump/fastqFiles
      nthreads: nthreads
      gibbs_samples: gibbs_samples
      num_bootstraps: num_bootstraps
    out:
      [quant_results]

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl
s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0003-3777-5945
    s:email: mailto:inutano@gmail.com
    s:name: Tazro Ohta

$schemas:
  - https://schema.org/version/latest/schemaorg-current-http.rdf
  - http://edamontology.org/EDAM_1.18.owl
