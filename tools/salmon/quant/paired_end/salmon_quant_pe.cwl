cwlVersion: v1.0
class: CommandLineTool
label: "Salmon quant: quantifying the samples"
doc: "Salmon is a tool for quantifying the expression of transcripts using RNA-seq data. Salmon uses new algorithms (specifically, coupling the concept of quasi-mapping with a two-phase inference procedure) to provide accurate expression estimates very quickly (i.e. wicked-fast) and while using little memory. Salmon performs its inference using an expressive and realistic model of RNA-seq data that takes into account experimental attributes and biases commonly observed in real RNA-seq data. http://salmon.readthedocs.io/en/latest/ (no documentation for command line options, see salmon quant --help-reads. salmon quant has many advanced options, here are only basic options defined.)"

hints:
  DockerRequirement:
    dockerPull: combinelab/salmon:0.10.2

baseCommand: [salmon, quant]

arguments:
  - prefix: --output
    valueFrom: $(runtime.outdir)/$(inputs.quant_out_dirname)

inputs:
  lib_type:
    label: "Format string describing the library type"
    doc: "Format string describing the library type"
    type: string
    default: IU
    inputBinding:
      prefix: --libType
  index_dir:
    label: "salmon index"
    doc: "salmon index"
    type: Directory
    inputBinding:
      prefix: --index
  quant_out_dirname:
    label: "Output quantification directory"
    doc: "Output quantification directory."
    type: string
    default: salmon_quant
  fq1:
    label: "File containing the #1 mates"
    doc: "File containing the #1 mates"
    type: File
    inputBinding:
      prefix: --mates1
  fq2:
    label: "File containing the #2 mates"
    doc: "File containing the #2 mates"
    type: File
    inputBinding:
      prefix: --mates2
  seq_bias:
    label: "Perform sequence-specific bias correction."
    doc: "Perform sequence-specific bias correction."
    type: boolean?
    inputBinding:
      prefix: --seqBias
  gc_bias:
    label: "[beta for single-end reads] Perform fragment GC bias correction"
    doc: "[beta for single-end reads] Perform fragment GC bias correction"
    type: boolean?
    inputBinding:
        prefix: --gcBias
  nthreads:
    label: "The number of threads to use concurrently."
    doc: "The number of threads to use concurrently."
    type: int
    default: 2
    inputBinding:
      prefix: --threads
  incompat_prior:
    label: "the prior probability that an alignment that disagrees with the specified library type (--libType) results from the true fragment origin"
    doc: "This option sets the prior probability that an alignment that disagrees with the specified library type (--libType) results from the true fragment origin. Setting this to 0 specifies that alignments that disagree with the library type should be 'impossible', while setting it to 1 says that alignments that disagree with the library type are no less likely than those that do"
    type: int
    default: 0
    inputBinding:
      prefix: --incompatPrior
  gene_map:
    label: "File containing a mapping of transcripts to genes"
    doc: "File containing a mapping of transcripts to genes. If this file is provided salmon will output both quant.sf and quant.genes.sf files, where the latter contains aggregated gene-level abundance estimates. The transcript to gene mapping should be provided as either a GTF file, or a in a simple tab-delimited format where each line contains the name of a transcript and the gene to which it belongs separated by a tab. The extension of the file is used to determine how the file should be parsed. Files ending in '.gtf', '.gff' or '.gff3' are assumed to be in GTF format; files with any other extension are assumed to be in the simple format. In GTF / GFF format, the 'transcript_id' is assumed to contain the transcript identifier and the 'gene_id' is assumed to contain the corresponding gene identifier."
    type: File?
    inputBinding:
      prefix: --geneMap
  meta:
    label: "a metagenomic dataset"
    doc: "If you're using Salmon on a metagenomic dataset, consider setting this flag to disable parts of the abundance estimation model that make less sense for metagenomic data."
    type: boolean
    default: false
    inputBinding:
      prefix: --meta
  gibbs_samples:
    label: "Number of Gibbs sampling rounds to perform."
    doc: "Number of Gibbs sampling rounds to perform."
    type: int
    default: 0
    inputBinding:
      prefix: --numGibbsSamples
  num_bootstraps:
    label: "Number of bootstrap samples to generate"
    doc: "Number of bootstrap samples to generate. Note: This is mutually exclusive with Gibbs sampling."
    type: int
    default: 0
    inputBinding:
      prefix: --numBootstraps

outputs:
  quant_results:
    type: Directory
    outputBinding:
      glob: $(inputs.quant_out_dirname)

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl
s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0003-3777-5945
    s:email: mailto:inutano@gmail.com
    s:name: Tazro Ohta

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
