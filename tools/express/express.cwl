cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/express
requirements:
  - class: InlineJavascriptRequirement
baseCommand: express
inputs:
  reference:
    type: File
    inputBinding:
      position: 1
  bam:
    type: File 
    inputBinding:
      position: 2
arguments: ["-o", "/var/spool/cwl"]
outputs:
  express_result:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*"
