cwlVersion: v1.0
class: CommandLineTool
label: "fastqc-util: from bio-fastqc, a ruby parser for FastQC"
doc: "Parse outputs from FastQC to create data to compare or analysis NGS data quality https://rubygems.org/gems/bio-fastqca"

hints:
  DockerRequirement:
    dockerPull: quay.io/inutano/bio-fastqc:v0.10.8

baseCommand: [fastqc-util, parse]

arguments:
  - prefix: --outdir
    valueFrom: $(runtime.outdir)

inputs:
  outputFormat:
    label: "output format"
    doc: "output format: tsv, json, ttl, or jsonld"
    type: string
    default: tsv
    inputBinding:
      prefix: --format
  fastqcResults:
    label: "a zipped fastqc result file"
    doc: "a zipped fastqc result file"
    type: File[]
    inputBinding:
      position: 100

outputs:
  fastqc_summary:
    type: File[]
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
