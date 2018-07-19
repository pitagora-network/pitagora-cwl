cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/samtools:1.9--h46bd0b3_0

baseCommand: [samtools, faidx]

requirements:
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
