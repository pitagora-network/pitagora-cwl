cwlVersion: v1.0
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/star

baseCommand: ["STAR"]

inputs:
  runThreadN:
    type: int
    inputBinding:
      prefix: --runThreadN
  outSJfilterReads:
    type: string
    inputBinding:
      prefix: --outSJfilterReads
  outFilterType:
    type: string
    inputBinding:
      prefix: --outFilterType
  outSAMunmapped:
    type: string
    inputBinding:
      prefix: --outSAMunmapped
  outSAMattributes:
    type: string[]
    inputBinding:
      prefix: --outSAMattributes
  outFilterMultimapNmax:
    type: int
    inputBinding:
      prefix: --outFilterMultimapNmax
  outFilterMismatchNmax:
    type: int
    inputBinding:
      prefix: --outFilterMismatchNmax
  alignIntronMin:
    type: int
    inputBinding:
      prefix: --alignIntronMin
  outFilterMismatchNoverReadLmax:
    type: float
    inputBinding:
      prefix: --outFilterMismatchNoverReadLmax
  alignIntronMax:
    type: int
    inputBinding:
      prefix: --alignIntronMax
  alignMatesGapMax:
    type: int
    inputBinding:
      prefix: --alignMatesGapMax
  alignSJoverhangMin:
    type: int
    inputBinding:
      prefix: --alignSJoverhangMin
  alignSJDBoverhangMin:
    type: int
    inputBinding:
      prefix: --alignSJDBoverhangMin
  sjdbScore:
    type: int
    inputBinding:
      prefix: --sjdbScore
  outSAMtype:
    type: string[]
    inputBinding:
      prefix: --outSAMtype
  outBAMcompression:
    type: int
    inputBinding:
      prefix: --outBAMcompression
  limitBAMsortRAM:
    type: long
    inputBinding:
      prefix: --limitBAMsortRAM
  quantMode:
    type: string[]
    inputBinding:
      prefix: --quantMode
  quantTranscriptomeBAMcompression:
    type: int
    inputBinding:
      prefix: --quantTranscriptomeBAMcompression
  outSAMstrandField:
    type: string
    inputBinding:
      prefix: --outSAMstrandField
  genomeDir:
    type: Directory
    inputBinding:
      prefix: --genomeDir
  outFileNamePrefix:
    type: string?
    inputBinding:
      prefix: --outFileNamePrefix
  readFilesIn:
    type: File
    inputBinding:
      prefix: --readFilesIn

outputs:
  sortedByCoord_bam:
    type: File
    outputBinding:
      glob: "*Aligned.sortedByCoord.out.bam"
  toTranscriptome_bam:
    type: File
    outputBinding:
      glob: "*Aligned.toTranscriptome.out.bam"
  readsPerGene:
    type: File
    outputBinding:
      glob: "*ReadsPerGene.out.tab"
  spliceJunctions:
    type: File
    outputBinding:
      glob: "*SJ.out.tab"
  logfiles:
    type: File[]
    outputBinding:
      glob: "*.out"
