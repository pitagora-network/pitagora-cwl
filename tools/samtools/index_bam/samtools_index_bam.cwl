cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/samtools:1.9--h46bd0b3_0

baseCommand: ["samtools", "index", "-b"]

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.input_bam)

inputs:
  input_bam:
    type: File
    inputBinding:
      position: 1
      valueFrom: $(self.basename)

outputs:
  bam_index:
    type: File
    outputBinding:
      glob: "*bai"

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
  - https://schema.org/version/latest/schemaorg-current-http.rdf
  - http://edamontology.org/EDAM_1.18.owl
