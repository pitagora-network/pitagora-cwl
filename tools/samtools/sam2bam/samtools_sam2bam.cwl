cwlVersion: v1.0
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/samtools:1.9--h46bd0b3_0

baseCommand: ["samtools", "view", "-b"]

arguments:
  - prefix: -o
    valueFrom: $(runtime.outdir)/$(inputs.output_filename)

inputs:
  output_filename:
    label: "Filename to write output to"
    doc: "Filename to write output to"
    type: string
    default: out.bam
  input_sam:
    label: "SAM format input file"
    doc: "SAM format input file"
    type: File
    inputBinding:
      position: 50

outputs:
  bamfile:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)

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
