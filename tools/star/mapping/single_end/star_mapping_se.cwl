cwlVersion: v1.0
class: CommandLineTool
label: "STAR mapping: running mapping jobs."
doc: "STAR: Spliced Transcripts Alignment to a Reference. https://github.com/alexdobin/STAR/blob/master/doc/STARmanual.pdf"

hints:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/star:2.6.0c--0

baseCommand: [STAR]

arguments:
  - prefix: --outFileNamePrefix
    valueFrom: $(runtime.outdir)/$(inputs.output_dir_name)

inputs:
  output_dir_name:
    label: "Name of the directory to write output files in"
    doc: "Name of the directory to write output files in"
    type: string
    default: STAR
  nthreads:
    label: "Number of threads"
    doc: "defines the number of threads to be used for genome generation, it has
to be set to the number of available cores on the server node."
    type: int
    inputBinding:
      prefix: --runThreadN
  outSJfilterReads:
    label: "which reads to consider for collapsed splice junctions output"
    doc: "which reads to consider for collapsed splice junctions output. All: all reads, unique- and multi-mappers, Unique: uniquely mapping reads only."
    type: string
    default: "Unique"
    inputBinding:
      prefix: --outSJfilterReads
  outFilterType:
    label: "type of filtering"
    doc: "Normal: standard filtering using only current alignment, BySJout: keep only those reads that contain junctions that passed filtering into SJ.out.tab"
    type: string
    default: "BySJout"
    inputBinding:
      prefix: --outFilterType
  outSAMunmapped:
    label: "output of unmapped reads in the SAM format"
    doc: "1st word: None: no output, Within: output unmapped reads within the main SAM file (i.e. Aligned.out.sam). 2nd word: KeepPairs: record unmapped mate for each alignment, and, in case of unsorted output, keep it adjacent to its mapped mate. Only a↵ects multi-mapping reads."
    type: string
    default: "Within"
    inputBinding:
      prefix: --outSAMunmapped
  outSAMattributes:
    label: "a string of desired SAM attributes, in the order desired for the output
SAM"
    doc: "NH: any combination in any order, Standard: NH HI AS nM, All: NH HI AS nM NM MD jM jI ch, None: no attributes"
    type: string[]
    default: ["NH", "HI", "AS", "NM", "MD"]
    inputBinding:
      prefix: --outSAMattributes
  outFilterMultimapNmax:
    label: "maximum number of loci the read is allowed to map to"
    doc: "maximum number of loci the read is allowed to map to. Alignments (all of them) will be output only if the read maps to no more loci than this value. Otherwise no alignments will be output, and the read will be counted as ”mapped to too many loci” in the Log.final.out ."
    type: int
    default: 20
    inputBinding:
      prefix: --outFilterMultimapNmax
  outFilterMismatchNmax:
    label: "alignment will be output only if it has no more mismatches than this value"
    doc: "alignment will be output only if it has no more mismatches than this value"
    type: int
    default: 999
    inputBinding:
      prefix: --outFilterMismatchNmax
  alignIntronMin:
    label: "minimum intron size"
    doc: "minimum intron size: genomic gap is considered intron if its length>=alignIntronMin, otherwise it is considered Deletion"
    type: int
    default: 20
    inputBinding:
      prefix: --alignIntronMin
  outFilterMismatchNoverReadLmax:
    label: "alignment will be output only if its ratio of mismatches to *read* length
is less than or equal to this value."
    doc: "alignment will be output only if its ratio of mismatches to *read* length
is less than or equal to this value."
    type: float
    default: 0.04
    inputBinding:
      prefix: --outFilterMismatchNoverReadLmax
  alignIntronMax:
    label: "maximum intron size"
    doc: "maximum intron size, if 0, max intron size will be determined by (2ˆwinBinNbits)*winAnchorDistNbins"
    type: int
    default: 1000000
    inputBinding:
      prefix: --alignIntronMax
  alignMatesGapMax:
    label: "maximum gap between two mates"
    doc: "maximum gap between two mates, if 0, max intron gap will be determined by (2ˆwinBinNbits)*winAnchorDistNbins"
    type: int
    default: 1000000
    inputBinding:
      prefix: --alignMatesGapMax
  alignSJoverhangMin:
    label: "minimum overhang (i.e. block size) for spliced alignments"
    doc: "minimum overhang (i.e. block size) for spliced alignments"
    type: int
    default: 8
    inputBinding:
      prefix: --alignSJoverhangMin
  alignSJDBoverhangMin:
    label: "minimum overhang (i.e. block size) for annotated (sjdb) spliced alignments"
    doc: "minimum overhang (i.e. block size) for annotated (sjdb) spliced alignments"
    type: int
    default: 1
    inputBinding:
      prefix: --alignSJDBoverhangMin
  sjdbScore:
    label: "extra alignment score for alignmets that cross database junctions"
    doc: "extra alignment score for alignmets that cross database junctions"
    type: int
    default: 1
    inputBinding:
      prefix: --sjdbScore
  outSAMtype:
    label: "type of SAM/BAM output"
    doc: "1st word: BAM: output BAM without sorting, SAM: output SAM without sorting, None: no SAM/BAM output, 2nd, 3rd: Unsorted: standard unsorted, SortedByCoordinate: sorted by coordinate. This option will allocate extra memory for sorting which can be specified by –limitBAMsortRAM"
    type: string[]
    default: ["BAM", "Unsorted"]
    inputBinding:
      prefix: --outSAMtype
  outBAMcompression:
    label: "BAM compression level"
    doc: "BAM compression level, -1=default compression (6?), 0=no compression, 10=maximum compression"
    type: int
    default: 10
    inputBinding:
      prefix: --outBAMcompression
  limitBAMsortRAM:
    label: "maximum available RAM for sorting BAM"
    doc: "maximum available RAM for sorting BAM. If =0, it will be set to the genome index size. 0 value can only be used with –genomeLoad NoSharedMemory option"
    type: long?
    inputBinding:
      prefix: --limitBAMsortRAM
  quantMode:
    label: "types of quantification requested"
    doc: "types of quantification requested. -: none, TranscriptomeSAM: output SAM/BAM alignments to transcriptome into a separate file, GeneCounts: count reads per gene"
    type: string[]
    default: ["TranscriptomeSAM", "GeneCounts"]
    inputBinding:
      prefix: --quantMode
  quantTranscriptomeBAMcompression:
    label: "transcriptome BAM compression level"
    doc: "transcriptome BAM compression level, -1=default compression (6?), 0=no compression, 10=maximum compression"
    type: int
    default: 10
    inputBinding:
      prefix: --quantTranscriptomeBAMcompression
  outSAMstrandField:
    label: "Cuffinks-like strand field flag"
    doc: "Cuffinks-like strand field flag. None: not used, intronMotif: strand derived from the intron motif. Reads with inconsistent and/or non-canonical introns are filtered out."
    type: string
    default: intronMotif
    inputBinding:
      prefix: --outSAMstrandField
  genomeDir:
    label: "path to the directory where genome files are stored"
    doc: "path to the directory where genome files are stored"
    type: Directory
    inputBinding:
      prefix: --genomeDir
  fq:
    label: "paths to files that contain input read"
    doc: "paths to files that contain input read1 (and, if needed, read2)"
    type: File[]
    inputBinding:
      prefix: --readFilesIn
      itemSeparator: ","

outputs:
  output_bam:
    type: File
    outputBinding:
      glob: "*Aligned.out.bam"
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
