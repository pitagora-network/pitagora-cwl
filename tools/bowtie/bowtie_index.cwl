cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: biodckrdev/bowtie:1.1.2
baseCommand: bowtie-build
requirements:
  - class: InlineJavascriptRequirement
inputs:
  override_offrate:
    type: int
    inputBinding:
      prefix: -o
      position: 1
  reference:
    type: File
    inputBinding:
      position: 2
  ebwt_base:
    type: string
    inputBinding:
      position: 3
outputs:
  result:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*"
