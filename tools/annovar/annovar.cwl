cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/annovar:20160201
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.vcf)
      - $(inputs.vcfidx)

baseCommand: table_annovar.pl

inputs:
  vcf:
    type: File
    inputBinding:
      position: 1
  vcfidx:
    type: File?
    inputBinding:
      position: 10
      valueFrom:
  reference:
    type: Directory
    inputBinding:
      position: 2
  version:
    type: string
    inputBinding:
      position: 3
      prefix: -buildver
  output: 
    type: string
    inputBinding:
      position: 4
      prefix: -out
  remove:
    type: boolean
    inputBinding:
      position: 5
      prefix: -remove
  protocol:
    type: string
    inputBinding:
      position: 6
      prefix: -protocol
  operation:
    type: string
    inputBinding:
      position: 7
      prefix: -operation
  nastring:
    type: string
    inputBinding:
      position: 8
      prefix: -nastring
  vcfinput:
    type: boolean
    inputBinding:
      position: 9
      prefix: -vcfinput
outputs:
  annovar_results:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*.annovar.*"

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
