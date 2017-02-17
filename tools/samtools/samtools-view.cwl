cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/samtools
baseCommand: ["samtools", "view"]
inputs:
  bs:
    type: boolean
    inputBinding:
      position: 1
      prefix: -bS
  bam:
    type: string
    inputBinding:
      position: 2
      prefix: -o
  sam:
    type: File
    inputBinding:
      position: 3
outputs:
  samtools-view_bam:
    type: File
    outputBinding:
      glob: $(inputs.bam)
