cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: biodckrdev/bowtie
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
  fq:
    type: File
    inputBinding:
      prefix: -q
      position: 6
  process:
    type: int?
    inputBinding:
      prefix: -p
      position: 7
  sam:
    type: string
    inputBinding:
      prefix: -S 
      position: 8
outputs:
  bowtie_sam:
    type: File
    outputBinding:
      glob: $(inputs.sam)
