cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/bowtie2:2.2.4
baseCommand: bowtie2
inputs:
  genome_index:
    type: File 
    inputBinding:
      position: 1
      prefix: -x
  fq1:
    type: File
    inputBinding:
      prefix: "-1"
      position: 2
  fq2:
    type: File
    inputBinding:
      prefix: "-2"
      position: 3
  set_read_group_id:
    type: string
    inputBinding:
      position: 4
      prefix: --rg-id
  add_text_sam_header1:
    type: string
    inputBinding:
      position: 5
      prefix: --rg
  add_text_sam_header2:
    type: string
    inputBinding:
      position: 6
      prefix: --rg
  output:
    type: string
    inputBinding:
      prefix: -S
      position: 7
  process:
    type: int?
    inputBinding:
      prefix: -p
      position: 8
outputs:
  bowtie2_sam:
    type: File
    outputBinding:
      glob: $(inputs.output)

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
