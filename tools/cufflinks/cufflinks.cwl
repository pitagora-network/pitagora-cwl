cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: nasuno/cufflinks:2.2.1
baseCommand: cufflinks
inputs:
  process:
    type: int?
    inputBinding:
      position: 1
      prefix: -p
  annotation:
    type: File
    inputBinding:
      position: 2
      prefix: -G
  bam:
    type: File
    inputBinding:
      position: 3
arguments:
  - prefix: -o
    valueFrom: $(runtime.outdir)
outputs:
  cufflinks_result:
    type:
      type: array
      items: File
    outputBinding:
      glob: '*'
