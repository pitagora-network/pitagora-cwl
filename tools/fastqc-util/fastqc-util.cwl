cwlVersion: v1.0
class: CommandLineTool
label: "fastqc-util: from bio-fastqc, a ruby parser for FastQC"
doc: "Parse outputs from FastQC to create data to compare or analysis NGS data quality https://rubygems.org/gems/bio-fastqca"

hints:
  DockerRequirement:
    dockerPull: quay.io/inutano/bio-fastqc:v0.10.7

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
