cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/bowtie2
baseCommand: bowtie2-build
requirements:
  - class: InlineJavascriptRequirement
inputs:
  reference:
    type: File
    inputBinding:
      position: 1
  ebwt2_base:
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
