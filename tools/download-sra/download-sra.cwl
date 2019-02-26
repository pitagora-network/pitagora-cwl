cwlVersion: v1.0
class: CommandLineTool
label: "download-sra: A simple download tool to get .sra file"
doc: "A simple download tool to get .sra file from a repository of INSDC members. https://github.com/inutano/download-sra"

hints:
  DockerRequirement:
    dockerPull: quay.io/inutano/download-sra:0.1.2

inputs:
  repo:
    type: string
    default: "ncbi"
    inputBinding:
      position: 1
      prefix: "-r"
  run_ids:
    type: string[]
    inputBinding:
      position: 2

outputs:
  sraFiles:
    type: File[]
    outputBinding:
      glob: "*sra"

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
