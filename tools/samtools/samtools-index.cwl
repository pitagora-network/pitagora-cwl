cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/samtools
baseCommand: ["samtools", "index"]
inputs:
  sortbam:
    type: File
    inputBinding:
      position: 1
  indexbam:
    type: string?
    inputBinding:
      position: 2
outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.indexbam)
