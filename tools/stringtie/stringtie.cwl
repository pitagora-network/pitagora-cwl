cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/stringtie:1.2.3
baseCommand: stringtie
requirements:
  - class: InlineJavascriptRequirement
inputs:
  bam:
    type: File
    inputBinding:
      position: 1
  annotation:
    type: File 
    inputBinding:
      position: 2
      prefix: -G
  process:
    type: int?
    inputBinding:
      position: 4
      prefix: -p
  output:
    type: string
    inputBinding:
      position: 3
      prefix: -o
outputs:
  stringtie_result:
    type: File
    outputBinding:
      glob: $(inputs.output)
