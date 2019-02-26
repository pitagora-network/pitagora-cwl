cwlVersion: v1.0
class: CommandLineTool
baseCommand: [grep, -v, '^\[']
requirements:
  - class: InlineJavascriptRequirement
inputs:
  tmpoutput:
    type: File
    inputBinding:
      position: 1
outputs:
  sam:
    type: File
    outputBinding:
      glob: "*"
stdout: $(inputs.tmpoutput.basename.replace('.tmp.sam', '.trim.sam'))

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
