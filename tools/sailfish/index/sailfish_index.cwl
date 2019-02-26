cwlVersion: v1.0
class: CommandLineTool
label: "sailfish index"
doc: "Sailfish: Rapid Alignment-free Quantification of Isoform Abundance"

hints:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/sailfish:0.10.1--h6516f61_3

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
