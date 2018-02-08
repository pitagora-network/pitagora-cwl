cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/last:894
baseCommand: lastal
requirements:
  - class: InlineJavascriptRequirement
inputs:
  input_format:
    type: int
    inputBinding:
      position: 1
      prefix: -Q
      separate: false
  gap_alignment_min_score:
    type: int
    inputBinding:
      position: 2
      prefix: -e
      separate: false
  genome_index:
    type: File 
    inputBinding:
      position: 3
  fq:
    type: File
    inputBinding:
      position: 4
  process:
    type: int?
    inputBinding:
      prefix: -P
      position: 5
outputs:
  maf:
    type: File
    outputBinding:
      glob: "*"
stdout: $(inputs.input.basename + '.maf')
