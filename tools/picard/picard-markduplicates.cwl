cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: broadinstitute/picard:latest
baseCommand: MarkDuplicates
inputs:
  bam:
    type: File 
    inputBinding:
      position: 1
      prefix: INPUT=
      separate: false
  output:
    type: string
    inputBinding:
      position: 2
      prefix: OUTPUT=
      separate: false
  metout: 
    type: string
    inputBinding:
      position: 3
      prefix: METRICS_FILE=
      separate: false
outputs:
  dupread:
    type: File
    outputBinding:
      glob: $(inputs.output)
  metrics:
    type: File
    outputBinding:
      glob: $(inputs.metout)
