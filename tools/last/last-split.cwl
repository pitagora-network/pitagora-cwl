cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/last:894
baseCommand: last-split
requirements:
  - class: InlineJavascriptRequirement
inputs:
  maf:
    type: File 
    inputBinding:
      position: 1
outputs:
  splitmaf:
    type: File
    outputBinding:
      glob: "*"
stdout: $((inputs.maf.basename).replace('.maf', '') + '.split.maf')
