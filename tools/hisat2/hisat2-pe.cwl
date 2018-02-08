cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: humancellatlas/hisat2:2-2.1.0
baseCommand: hisat2
inputs:
  gi:
    type: File 
    inputBinding:
      position: 1
      prefix: -x
  dta:
    type: boolean
    inputBinding:
      position: 2
      prefix: --dta
  dta_cufflinks:
    type: boolean
    inputBinding:
      position: 3
      prefix: --dta-cufflinks
  output:
    type: string
    inputBinding:
      prefix: -S
      position: 6
  process:
    type: int?
    inputBinding:
      prefix: -p
      position: 7
  fq1:
    type: File
    inputBinding:
      prefix: "-1"
      position: 4
  fq2:
    type: File
    inputBinding:
      prefix: "-2"
      position: 5
outputs:
  - id: hisat2_sam
    type: File
    outputBinding:
      glob: $(inputs.output)
