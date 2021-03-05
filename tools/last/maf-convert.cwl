cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/last:894
baseCommand: maf-convert
requirements:
  - class: InlineJavascriptRequirement
inputs:
  format_type:
    type: string
    inputBinding:
      position: 1
  maf1:
    type: File
    inputBinding:
      position: 2
  maf2:
    type: File?
    inputBinding:
      position: 3
  dictionary:
    type: File
    inputBinding:
      position: 4
      prefix: -d
outputs:
  sam:
    type: File
    outputBinding:
      glob: "*"
stdout: $((inputs.maf1.basename).replace('.maf', '').replace('_1', '') + '.sam')

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
