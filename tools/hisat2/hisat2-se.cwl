cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: limesbonn/hisat2
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
  fq:
    type: File
    inputBinding:
      position: 4
outputs:
  - id: hisat2_sam
    type: File
    outputBinding:
      glob: $(inputs.output)
