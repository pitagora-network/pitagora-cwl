cwlVersion: v1.0
class: CommandLineTool

hints:
 DockerRequirement:
   dockerPull: quay.io/inutano/download-sra:0.1.2

inputs:
  repo:
    type: string
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
