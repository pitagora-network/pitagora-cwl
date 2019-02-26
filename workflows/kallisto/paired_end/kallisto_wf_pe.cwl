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
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
