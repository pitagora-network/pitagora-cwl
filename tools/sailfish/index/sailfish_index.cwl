cwlVersion: v1.0
class: CommandLineTool
label: "sailfish index"
doc: "Sailfish: Rapid Alignment-free Quantification of Isoform Abundance"

hints:
  DockerRequirement:
    dockerPull: yyabuki/sailfish:0.10.0

baseCommand: [sailfish, index]

arguments:
  - prefix: --out
    valueFrom: $(runtime.outdir)/$(inputs.index_name)

inputs:
  transcript_fasta:
    label: "Transcript fasta file(s)"
    doc: "Transcript fasta file(s)"
    type: File[]
    inputBinding:
      prefix: --transcripts
  kmer_size:
    label: "Kmer size."
    doc: "Kmer size."
    type: int
    default: 31
    inputBinding:
      prefix: --kmerSize
  index_name:
    label: "sailfish index name"
    doc: "sailfish index name"
    type: string
  perfect_hash:
    label: "Build the index using a perfect hash rather than a dense hash"
    doc: "[quasi index only] Build the index using a perfect hash rather than a dense hash. This will require less memory (especially during quantification), but will take longer to construct"
    type: boolean?
    inputBinding:
      prefix: --perfectHash
  nthreads:
    label: "Number of threads"
    doc: "Number of threads to use (only used for computing bias features)"
    type: int
    default: 2
    inputBinding:
      prefix: --threads

outputs:
  sailfish_index:
    type: Directory
    outputBinding:
      glob: $(inputs.index_name)
