cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/last:894
baseCommand: last-split
requirements:
  - class: InlineJavascriptRequirement
inputs:
  maf:
    type: File 
    inputBinding:
      position: 1
outputs:
  splitmaf:
    type: File
    outputBinding:
      glob: "*"
stdout: $((inputs.maf.basename).replace('.maf', '') + '.split.maf')

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
