cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: nasuno/tophat2:2.0.9
baseCommand: tophat2
requirements:
  - class: InlineJavascriptRequirement
inputs:
  gtf:
    type: File
    inputBinding:
      prefix: -G
      position: 1
#  output:
#    type: Directory
#    inputBinding:
#      prefix: -o
#      position: 2
  genome_index:
    type: File 
    inputBinding:
      position: 3
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
              position: 4
          fq2:
            type: File
            inputBinding:
              position: 5
  process:
    type: int?
    inputBinding:
      prefix: -p
      position: 6
arguments: ["-o", "/var/spool/cwl"]
outputs:
  bam:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*"
