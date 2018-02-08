cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/bowtie2:2.2.4
baseCommand: bowtie2-build
requirements:
  - class: InlineJavascriptRequirement
inputs:
  reference:
    type: File
    inputBinding:
      position: 1
  bt2_base:
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
