cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: broadinstitute/picard:latest
baseCommand: CreateSequenceDictionary
inputs:
  reference:
    type: File
    inputBinding:
      prefix: R=
      position: 1
      separate: false
  dict:
    type: string
    inputBinding:
      prefix: O=
      position: 2
      separate: false
outputs:
  result:
    type: File
    outputBinding:
      glob: $(inputs.dict)

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
