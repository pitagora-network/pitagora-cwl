cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: nasuno/tophat2:2.0.9
baseCommand: tophat2

inputs:
  process:
    type: int?
    inputBinding:
      prefix: -p
      position: 1
  gtf:
    type: File
    inputBinding:
      prefix: -G
      position: 2
  gi:
    type: File
    inputBinding:
      position: 3
  read_layout:
    type:
      type: enum
      symbols:
        - single end
        - pair end
  fastq:
    type:
      - type: record
        label: single end
        fields:
          fq:
            type: File
            inputBinding:
              position: 4
              valueFrom: |
                ${
                  if (inputs.read_layout != "single end") {
                    throw new Error('A parameter "fq" is valid if "read_layout" is "single end"')
                  }
                  return self
                }
      - type: record
        label: pair end
        fields:
          fq1:
            type: File
            inputBinding:
              position: 4
              valueFrom: |
                ${
                  if (inputs.read_layout != "pair end") {
                    throw new Error('A parameter "fq1" is valid if "read_layout" is "pair end"')
                  }
                  return self
                }
          fq2:
            type: File
            inputBinding:
              position: 5
arguments: ["-o", "/var/spool/cwl"]
outputs:
  tophat2_bam:
    type: File
    outputBinding:
      glob: "accepted_hits.bam"
