cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/express:1.5.1
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
arguments:
  - prefix: -o
    valueFrom: $(runtime.outdir)
outputs:
  express_result:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*"
