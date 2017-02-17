cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/samtools
baseCommand: ["samtools", "index"]
requirements:
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.sortbam)
inputs:
  sortbam:
    type: File
    inputBinding:
      position: 1
      valueFrom: $(self.basename)
  indexbam:
    type: string
    inputBinding:
      position: 2
outputs:
  samtools-index_indexbam:
    type: File
    outputBinding:
      glob: $(inputs.indexbam)
