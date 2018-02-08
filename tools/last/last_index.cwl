cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/last:894
baseCommand: lastdb
requirements:
  - class: InlineJavascriptRequirement
inputs:
  seeding_scheme:
    type: boolean
    inputBinding:
      prefix: -uNEAR
      position: 1
  genome_index:
    type: string
    inputBinding:
      position: 2
  reference:
    type: File
    inputBinding:
      position: 3
  index_position:
    type: int?
    inputBinding:
      position: 4
      prefix: -w
      separate: false
outputs:
  result:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*"
