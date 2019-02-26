cwlVersion: v1.0
class: CommandLineTool
label: "kallisto index: builds an index from a FASTA formatted file of target sequences"
doc: "kallisto is a program for quantifying abundances of transcripts from RNA-Seq data, or more generally of target sequences using high-throughput sequencing reads. https://pachterlab.github.io/kallisto/manual.html#index"

hints:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/kallisto:0.44.0--h7d86c95_2

baseCommand: [kallisto, index]

arguments:
  - prefix: -i
    valueFrom: $(runtime.ourdir)/$(inputs.index_name)

inputs:
  index_name:
    label: "Filename for the kallisto index to be constructed"
    doc: "Filename for the kallisto index to be constructed"
    type: string
  kmer_size:
    label: "k-mer (odd) length (default: 31, max value: 31)"
    doc: "k-mer (odd) length (default: 31, max value: 31)"
    type: int
    default: 31
    inputBinding:
      prefix: -k
  make_unique:
    label: "Replace repeated target names with unique names"
    doc: "Replace repeated target names with unique names"
    type: boolean
    default: true
    inputBinding:
      prefix: --make-unique
  fasta_files:
    label: "The Fasta file supplied can be either in plaintext or gzipped format"
    doc: "The Fasta file supplied can be either in plaintext or gzipped format"
    type: File[]
    inputBinding:
      position: 10

outputs:
  index_file:
    type: File
    outputBinding:
      glob: $(inputs.index_name)

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
