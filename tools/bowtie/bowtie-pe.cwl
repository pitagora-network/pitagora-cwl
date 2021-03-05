cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: biodckrdev/bowtie:1.1.2
baseCommand: bowtie
requirements:
  - class: InlineJavascriptRequirement
inputs:
  all_alignment:
    type: boolean
    inputBinding:
      prefix: -a
      position: 1
  max_insert_size:
    type: int
    inputBinding:
      prefix: -X
      position: 2
  override_offrate:
    type: int
    inputBinding:
      prefix: -o
      position: 3
  max_ram_mb:
    type: int?
    inputBinding:
      prefix: --chunkmbs
      position: 4
  reference:
    type: File
    inputBinding:
      position: 5
  fq1:
    type: File
    inputBinding:
      prefix: "-1"
      position: 6
  fq2:
    type: File
    inputBinding:
      prefix: "-2"
      position: 7
  process:
    type: int?
    inputBinding:
      prefix: -p
      position: 8
  sam:
    type: string
    inputBinding:
      prefix: -S 
      position: 9
outputs:
  bowtie_sam:
    type: File
    outputBinding:
      glob: $(inputs.sam)

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
