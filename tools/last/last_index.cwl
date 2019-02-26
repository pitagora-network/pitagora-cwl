cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/last:894
baseCommand: lastdb
requirements:
  - class: InlineJavascriptRequirement
inputs:
  seeding_scheme:
    type: boolean
    inputBinding:
      prefix: -uNEAR
      position: 1
  genome_index:
    type: string
    inputBinding:
      position: 2
  reference:
    type: File
    inputBinding:
      position: 3
  index_position:
    type: int?
    inputBinding:
      position: 4
      prefix: -w
      separate: false
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
