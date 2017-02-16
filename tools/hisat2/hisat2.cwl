cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: limesbonn/hisat2
baseCommand: hisat2
inputs:
  genome_index:
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
  exclusive_parameters:
    type:
      - type: record
        name: singleend
        fields:
          fq:
            type: File
            inputBinding:
              position: 4
      - type: record
        name: pairend
        fields:
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
  - id: sam
    type: File
    outputBinding:
      glob: $(inputs.output)
