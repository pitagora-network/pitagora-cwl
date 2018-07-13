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
