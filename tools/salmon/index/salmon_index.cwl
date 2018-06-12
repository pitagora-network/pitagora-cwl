cwlVersion: v1.0
class: CommandLineTool
label: "Salmon index: building an index"
doc: "Salmon is a tool for quantifying the expression of transcripts using RNA-seq data. Salmon uses new algorithms (specifically, coupling the concept of quasi-mapping with a two-phase inference procedure) to provide accurate expression estimates very quickly (i.e. wicked-fast) and while using little memory. Salmon performs its inference using an expressive and realistic model of RNA-seq data that takes into account experimental attributes and biases commonly observed in real RNA-seq data. http://salmon.readthedocs.io/en/latest/ (document has no description for command line options, see salmon index --help)"

hints:
  DockerRequirement:
    dockerPull: combinelab/salmon:0.10.2

baseCommand: [salmon, index]

arguments:
  - prefix: -i
    valueFrom: $(runtime.outdir)/$(inputs.index_name)

inputs:
  transcript_fasta:
    label: "Transcript fasta file"
    doc: "Transcript fasta file"
    type: File
    inputBinding:
      prefix: --transcripts
  kmer_length:
    label: "The size of k-mers"
    doc: "The size of k-mers that should be used for the quasi index."
    type: int
    default: 31
    inputBinding:
      prefix: --kmerLen
  index_name:
    label: "salmon index name"
    doc: "salmon index name"
    type: string
  gencode:
    label: "expect the input transcript fasta to be in GENCODE format"
    doc: "This flag will expect the input transcript fasta to be in GENCODE format, and will split the transcript name at the first '|' character. These reduced names will be used in the output and when looking for these transcripts in a gene to transcript GTF."
    type: boolean?
    inputBinding:
      prefix: --gencode
  keep_duplicate:
    label: "disable discarding sequence-identical duplicate transcripts"
    doc: "This flag will disable the default indexing behavior of discarding sequence-identical duplicate transcripts. If this flag is passed, then duplicate transcripts that appear in the input will be retained and quantified separately."
    type: boolean?
    inputBinding:
      prefix: --keepDuplicates
  nthreads:
    label: "Number of threads"
    doc: "Number of threads to use (only used for computing bias features)"
    type: int
    default: 2
    inputBinding:
      prefix: --threads
  perfect_hash:
    label: "Build the index using a perfect hash rather than a dense hash"
    doc: "[quasi index only] Build the index using a perfect hash rather than a dense hash. This will require less memory (especially during quantification), but will take longer to construct"
    type: boolean?
    inputBinding:
      prefix: --perfectHash
  index_type:
    label: "The type of index to build"
    doc: "The type of index to build; options are 'fmd' and 'quasi' 'quasi' is recommended, and 'fmd' may be removed in the future"
    type: string
    default: quasi
    inputBinding:
      prefix: --type
  sasamp:
    label: "The interval at which the suffix array should be sampled"
    doc: "The interval at which the suffix array should be sampled. Smaller values are faster, but produce a larger index. The default should be OK, unless your transcriptome is huge. This value should be a power of 2."
    type: int
    default: 1
    inputBinding:
      prefix: --sasamp

outputs:
  salmon_index:
    type: Directory
    outputBinding:
      glob: $(inputs.index_name)
