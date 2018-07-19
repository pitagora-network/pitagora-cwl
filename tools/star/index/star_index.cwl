cwlVersion: v1.0
class: CommandLineTool
label: "STAR genomeGenerate: Generating genome indexes."
doc: "STAR: Spliced Transcripts Alignment to a Reference. https://github.com/alexdobin/STAR/blob/master/doc/STARmanual.pdf"

hints:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/star:2.6.0c--0

baseCommand: [STAR, --runMode, genomeGenerate]

arguments:
  - prefix: "--genomeDir"
    valueFrom: $(runtime.outdir)

inputs:
  nthreads:
    label: "Number of threads"
    doc: "defines the number of threads to be used for genome generation, it has
to be set to the number of available cores on the server node."
    type: int
    inputBinding:
      prefix: --runThreadN
  genomeFastaFiles:
    label: "Paths to genome fasta files"
    doc: "specified one or more FASTA files with the genome reference sequences. Multiple reference sequences (henceforth called chromosomes) are allowed for each fasta file. You can rename the chromosomes names in the chrName.txt keeping the order of the chromo- somes in the file: the names from this file will be used in all output alignment files (such as .sam). The tabs are not allowed in chromosomes names, and spaces are not recommended."
    type: File[]
    inputBinding:
      prefix: --genomeFastaFiles
  sjdbGTFfile:
    label: "Path to annotation gtf file"
    doc: "specifies the path to the file with annotated transcripts in the standard GTF format. STAR will extract splice junctions from this file and use them to greatly improve accuracy of the mapping. While this is optional, and STAR can be run without annotations, using annotations is highly recommended whenever they are available. Starting from 2.4.1a, the annotations can also be included on the fly at the mapping step."
    type: File
    inputBinding:
      prefix: --sjdbGTFfile
  sjdbOverhang:
    label: "ReadLength-1, a value to be used for spliced junction database construction"
    doc: "specifies the length of the genomic sequence around the annotated junction to be used in constructing the splice junctions database. Ideally, this length should be equal to the ReadLength-1, where ReadLength is the length of the reads. For instance, for Illumina 2x100b paired-end reads, the ideal value is 100-1=99. In case of reads of varying length, the ideal value is max(ReadLength)-1. In most cases, the default value of 100 will work as well as the ideal value"
    type: int
    default: 100
    inputBinding:
      prefix: --sjdbOverhang

outputs:
  starIndex:
    type: File[]
    outputBinding:
      glob: "*"
