cwlVersion: v1.0
class: CommandLineTool
label: "kallisto quant: runs the quantification algorithm"
doc: "kallisto is a program for quantifying abundances of transcripts from RNA-Seq data, or more generally of target sequences using high-throughput sequencing reads. https://pachterlab.github.io/kallisto/manual.html#quant"

hints:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/kallisto:0.44.0--h7d86c95_2
baseCommand: ["kallisto", "quant", "--single"]

arguments:
  - prefix: -o
    valueFrom: $(runtime.outdir)/$(inputs.out_dir_name)

inputs:
  index_file:
    label: "[Required] Filename for the kallisto index"
    doc: "Filename for the kallisto index to be used for quantification"
    type: File
    inputBinding:
      prefix: -i
  out_dir_name:
    label: "Name of the directory to write output to"
    doc: "Name of the directory to write output to (default: kallisto_quant)"
    type: string
    default: "kallisto_quant"
  bias:
    label: "Perform sequence based bias correction"
    doc: "Perform sequence based bias correction"
    type: boolean?
    inputBinding:
      prefix: --bias
  bootstrap_samples:
    label: "Number of bootstrap samples"
    doc: "Number of bootstrap samples (default: 0)"
    type: int
    default: 0
    inputBinding:
      prefix: --bootstrap-samples=
      separate: false
  seed:
    label: "Seed for the bootstrap sampling"
    doc: "Seed for the bootstrap sampling (default: 42)"
    type: int
    default: 42
    inputBinding:
      prefix: --seed=
      separate: false
  plain_text:
    label: "Output plaintext instead of HDF5"
    doc: "Output plaintext instead of HDF5"
    type: boolean?
    inputBinding:
      prefix: --plaintext
  fusion:
    label: "Search for fusions for Pizzly"
    doc: "Search for fusions for Pizzly"
    type: boolean?
    inputBinding:
      prefix: --fusion
  fr_stranded:
    label: "Strand specific reads, first read forward"
    doc: "Strand specific reads, first read forward"
    type: boolean?
    inputBinding:
      prefix: --fr-stranded
  rf_stranded:
    label: "Strand specific reads, first read reverse"
    doc: "Strand specific reads, first read reverse"
    type: boolean?
    inputBinding:
      prefix: --rf-stranded
  single_overhang:
    label: "Include overhanged reads"
    doc: "Include reads where unobserved rest of fragment is predicted to lie outside a transcript"
    type: boolean?
    inputBinding:
      prefix: --single-overhang
  fragment_length:
    label: "Estimated average fragment length"
    doc: "Estimated average fragment length"
    type: double?
    default: 200
    inputBinding:
      prefix: --fragment-length=
      separate: false
  standard_deviation:
    label: "Estimated standard deviation of fragment length"
    doc: "Estimated standard deviation of fragment length (default: -l, -s values are estimated from paired end data, but are required when using --single)"
    type: double?
    default: 20
    inputBinding:
      prefix: --sd=
      separate: false
  nthreads:
    label: "Number of threads"
    doc: "Number of threads to use (default: 1)"
    type: int?
    default: 1
    inputBinding:
      prefix: --threads=
      separate: false
  pseudo_bam:
    label: "Save pseudoalignments to transcriptome to BAM file"
    doc: "Save pseudoalignments to transcriptome to BAM file"
    type: boolean?
    inputBinding:
      prefix: --pseudobam
  genome_bam:
    label: "Project pseudoalignments to genome sorted BAM file"
    doc: "Project pseudoalignments to genome sorted BAM file"
    type: boolean?
    inputBinding:
      prefix: --genomebam
  gtf:
    label: "GTF file for transcriptome information"
    doc: "GTF file for transcriptome information (required for --genomebam)"
    type: File?
    inputBinding:
      prefix: --gtf
  chromosome:
    label: "Tab separated file with chrosome names and lengths"
    doc: "Tab separated file with chrosome names and lengths (optional for --genomebam, but recommended)"
    type: File?
    inputBinding:
      prefix: --chromosome
  fq:
    label: "Input FASTQ file(s)"
    doc: "Input FASTQ file(s)"
    type: File[]
    inputBinding:
      position: 50

outputs:
  quant_output:
    type: Directory
    outputBinding:
      glob: $(inputs.out_dir_name)

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
