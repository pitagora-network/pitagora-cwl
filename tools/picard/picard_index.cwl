cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: broadinstitute/picard
baseCommand: CreateSequenceDictionary
inputs:
  reference:
    type: File
    inputBinding:
      prefix: R=
      position: 1
      separate: false
  dict:
    type: string
    inputBinding:
      prefix: O=
      position: 2
      separate: false
outputs:
  result:
    type: File
    outputBinding:
      glob: $(inputs.dict)
