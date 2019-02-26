cwlVersion: v1.0
class: CommandLineTool
label: "The hisat2-build indexer"
doc: "The hisat2-build indexer: hisat2-build builds a HISAT2 index from a set of DNA sequences. https://ccb.jhu.edu/software/hisat2/manual.shtml#the-hisat2-build-indexer"

hints:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/hisat2:2.1.0--py36h2d50403_1

baseCommand: [hisat2-build]

inputs:
  reference_fasta:
    type: File
    inputBinding:
      position: 1
  index_basename:
    type: string
    inputBinding:
      position: 2

outputs:
  index_files:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*"

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
