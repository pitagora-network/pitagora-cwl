cwlVersion: v1.0
class: CommandLineTool
requirements:
  - class: InlineJavascriptRequirement
hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/star
baseCommand: STAR
inputs:
  genome_directory:
    type: Directory
    inputBinding:
      position: 1
      prefix: --genomeDir
  gtf:
    type: File
    inputBinding:
      position: 2
      prefix: --sjdbGTFfile
  out_sam_type:
    type: string
    inputBinding:
      position: 3
      prefix: --outSAMtype BAM
  out_name_prefix:
    type: string
    inputBinding:
      position: 4
      prefix: --outFileNamePrefix
  out_sam_strand_field:
    type: string
    inputBinding:
      position: 5
      prefix: --outSAMstrandField
  process:
    type: int?
    inputBinding:
      prefix: --runThreadN
      position: 8
  fq1:
    type: File
    inputBinding:
      prefix: --readFilesIn
      position: 6
  fq2:
    type: File
    inputBinding:
      position: 7
outputs:
  star_bam:
    type: File
    outputBinding:
      glob: "*.bam"
