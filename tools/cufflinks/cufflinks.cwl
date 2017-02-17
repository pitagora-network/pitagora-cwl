cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: nasuno/cufflinks:2.2.1
baseCommand: cufflinks
requirements:
  - class: InlineJavascriptRequirement
inputs:
  process:
    type: int?
    inputBinding:
      position: 1
      prefix: -p
  annotation:
    type: File 
    inputBinding:
      position: 2
      prefix: -G
  bam:
    type: File
    inputBinding:
      position: 3
arguments: ["-o", "/var/spool/cwl"]
outputs:
  cufflinks_result:
    type:
      type: array
      items: File
    outputBinding:
      glob: '*'
