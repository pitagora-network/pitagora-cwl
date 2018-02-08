cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: broadinstitute/picard:latest
baseCommand: AddOrReplaceReadGroups
inputs:
  bam:
    type: File 
    inputBinding:
      position: 1
      prefix: I=
      separate: false
  output:
    type: string
    inputBinding:
      position: 2
      prefix: O=
      separate: false
  rgid: 
    type: string
    inputBinding:
      position: 3
      prefix: RGID=
      separate: false
  rglb:
    type: string
    inputBinding:
      position: 4
      prefix: RGLB=
      separate: false
  rgpl:
    type: string
    inputBinding:
      position: 5
      prefix: RGPL=
      separate: false
  rgpu:
    type: string
    inputBinding:
      position: 6
      prefix: RGPU=
      separate: false
  rgsm:
    type: string
    inputBinding:
      position: 7
      prefix: RGSM=
      separate: false
outputs:
  fix:
    type: File
    outputBinding:
      glob: $(inputs.output)
