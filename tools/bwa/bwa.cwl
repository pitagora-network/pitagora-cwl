cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/bwa
baseCommand: bwa
stdout: tmp.sam
inputs:
  mem:
    type: boolean
    inputBinding:
      position: 1
      prefix: mem
  mark_shorter_split_hits:
    type: boolean
    inputBinding:
      position: 2
      prefix: -M
  read_group_header_line:
    type: string
    inputBinding:
      position: 3
      prefix: -R
  genome_index:
    type: File 
    inputBinding:
      position: 4
  exclusive_parameters:
    type:
      - type: record
        name: singleend
        fields:
          fq:
            type: File
            inputBinding:
              position: 5
      - type: record
        name: pairend
        fields:
          fq1:
            type: File
            inputBinding:
              position: 5
          fq2:
            type: File
            inputBinding:
              position: 6
  process:
    type: int?
    inputBinding:
      prefix: -t
      position: 7
outputs:
  tmpsam:
    type: stdout
