cwlVersion: v1.0
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: inutano/rsubread:0.1.1

requirements:
  - class: InlineJavascriptRequirement

baseCommand: [Rscript]

arguments: ["--vanilla", $(inputs.readcount_script)]

inputs:
  bam:
    type: File
    inputBinding:
      prefix: --bam

  gtf:
    type: File
    inputBinding:
      prefix: --gtf

  readcount_script:
    type: File

outputs:
  readCount:
    type: File
    outputBinding:
      glob: "*_rc.txt"
