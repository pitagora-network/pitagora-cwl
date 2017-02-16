cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/bowtie2
baseCommand: bowtie2
inputs:
  genome_index:
    type: File
    inputBinding:
      position: 1
      prefix: -x
  exclusive_parameters:
    type:
      - type: record
        name: singleend
        fields:
          fq:
            type: File
            inputBinding:
              prefix: -q
              position: 2
      - type: record
        name: pairend
        fields:
          fq1:
            type: File
            inputBinding:
              prefix: "-1"
              position: 2
          fq2:
            type: File
            inputBinding:
              prefix: "-2"
              position: 3
  set_read_group_id:
    type: string
    inputBinding:
      position: 4
      prefix: --rg-id
  add_text_sam_header1:
    type: string
    inputBinding:
      position: 5
      prefix: --rg
  add_text_sam_header2:
    type: string
    inputBinding:
      position: 6
      prefix: --rg
  output:
    type: string
    inputBinding:
      prefix: -S
      position: 7
  process:
    type: int?
    inputBinding:
      prefix: -p
      position: 8
outputs:
  - id: sam
    type: File
    outputBinding:
      glob: $(inputs.output)
