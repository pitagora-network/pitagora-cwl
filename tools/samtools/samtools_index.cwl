cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/samtools
baseCommand: [samtools, faidx]
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.reference)
inputs:
  reference:
    type: File
    inputBinding:
      position: 1
      valueFrom: $(self.basename)
outputs:
  result:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*"
