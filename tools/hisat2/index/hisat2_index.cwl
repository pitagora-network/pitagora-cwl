cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: humancellatlas/hisat2:2-2.1.0

baseCommand: [hisat2-build]

inputs:
  reference_fasta:
    type: File
    inputBinding:
      position: 1
  index_basename:
    type: string
    inputBinding:
      position: 2

outputs:
  index_files:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*"
