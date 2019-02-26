cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/bowtie2:2.2.4
baseCommand: bowtie2-build
requirements:
  - class: InlineJavascriptRequirement
inputs:
  reference:
    type: File
    inputBinding:
      position: 1
  bt2_base:
    type: string
    inputBinding:
      position: 2
outputs:
  result:
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

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
