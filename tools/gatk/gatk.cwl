cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: biodckrdev/gatk
requirements:
  - class: InlineJavascriptRequirement
baseCommand: [java, -jar, /home/biodocker/bin/gatk/target/GenomeAnalysisTK.jar]
inputs:
  program:
    type: string
    inputBinding:
      position: 1
      prefix: -T
  reference:
    type: File
    inputBinding:
      position: 2
      prefix: -R
  bam:
    type: File
    inputBinding:
      position: 3
      prefix: -I
  output: 
    type: string
    inputBinding:
      position: 4
      prefix: -o
  interval:
    type: File?
    inputBinding:
      position: 5
      prefix: -targetIntervals
  knownsite:
    type: File?
    inputBinding:
      position: 6
      prefix: -knownSites
  base_quality_score_recalib:
    type: File?
    inputBinding:
      position: 7
      prefix: -BQSR
outputs:
  result:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*"
