cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: broadinstitute/picard:latest
baseCommand: ReorderSam
inputs:
  dupread:
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
  reference: 
    type: File
    inputBinding:
      position: 3
      prefix: REFERENCE=
      separate: false
outputs:
  reorderres:
    type: File
    outputBinding:
      glob: $(inputs.output)
