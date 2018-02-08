cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: humancellatlas/hisat2:2-2.1.0
baseCommand: hisat2-build
requirements:
  - class: InlineJavascriptRequirement
inputs:
  reference:
    type: File
    inputBinding:
      position: 1
  index_base:
    type: string
    inputBinding:
      position: 2
outputs:
  result:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*"
