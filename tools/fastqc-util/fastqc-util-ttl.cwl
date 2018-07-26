cwlVersion: v1.0
class: CommandLineTool
label: "fastqc-util-ttl: FastQC summary in RDF/turtle"
doc: "Parse outputs from FastQC to create data to compare or analysis NGS data quality https://rubygems.org/gems/bio-fastqca"

hints:
  DockerRequirement:
    dockerPull: quay.io/inutano/bio-fastqc:v0.10.8

baseCommand: [fastqc-util, parse, --format, ttl]

arguments:
  - prefix: --outdir
    valueFrom: $(runtime.outdir)

inputs:
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
      glob: "*ttl"
