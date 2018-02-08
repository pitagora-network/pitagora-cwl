cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: biodckrdev/gatk:3.4
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.bam)
      - $(inputs.bai)

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
      prefix: -I
      position: 3
      valueFrom: $(self.basename)
  bai:
    type: File?
    inputBinding:
      position: 8
      valueFrom: 
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
  dummy:
    type: File?
    inputBinding:
      position: 9
      valueFrom:
  skipaic:
    type: boolean?
    inputBinding:
      position: 10
      prefix: --disable_auto_index_creation_and_locking_when_reading_rods
outputs:
  vcf:
    type: File?
    outputBinding:
      glob: "*.vcf"
  vcfidx:
    type: File?
    outputBinding:
      glob: "*.vcf.idx"
  print:
    type: File?
    outputBinding:
      glob: "*.recal.bam"
  printbai:
    type: File?
    outputBinding:
      glob: "*.recal.bai"
  table:
    type: File?
    outputBinding:
      glob: "*.fix.table"
  interval_res:
    type: File?
    outputBinding:
      glob: "*.intervals"
  realign:
    type: File?
    outputBinding:
      glob: "*.reali.bam"
  realignbai:
    type: File?
    outputBinding:
      glob: "*.reali.bai"
  result:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*"
