cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: biodckrdev/bowtie
baseCommand: bowtie
requirements:
  - class: InlineJavascriptRequirement
inputs:
  all_alignment:
    type: boolean
    inputBinding:
      prefix: -a
      position: 1
  max_insert_size:
    type: int
    inputBinding:
      prefix: -X
      position: 2
  override_offrate:
    type: int
    inputBinding:
      prefix: -o
      position: 3
  max_ram_mb:
    type: int?
    inputBinding:
      prefix: --chunkmbs
      position: 4
  reference:
    type: File
    inputBinding:
      position: 5
  exclusive_parameters:
    type:
      - type: record
        name: singleend
        fields:
          fq:
            type: File
            inputBinding:
              prefix: -q
              position: 6
      - type: record
        name: pairend
        fields:
          fq1:
            type: File
            inputBinding:
              prefix: "-1"
              position: 6
          fq2:
            type: File
            inputBinding:
              prefix: "-2"
              position: 7
  process:
    type: int?
    inputBinding:
      prefix: -p
      position: 8
  sam:
    type: string
    inputBinding:
      prefix: -S 
      position: 9
outputs:
  output:
    type: File
    outputBinding:
      glob: "*.sam"
