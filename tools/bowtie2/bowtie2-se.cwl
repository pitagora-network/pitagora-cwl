cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/bowtie2
baseCommand: bowtie2
inputs:
  genome_index:
    type: File 
    inputBinding:
      position: 1
      prefix: -x
  fq:
    type: File
    inputBinding:
      prefix: -q
      position: 2
  set_read_group_id:
    type: string
    inputBinding:
      position: 3
      prefix: --rg-id
  add_text_sam_header1:
    type: string
    inputBinding:
      position: 4
      prefix: --rg
  add_text_sam_header2:
    type: string
    inputBinding:
      position: 5
      prefix: --rg
  output:
    type: string
    inputBinding:
      prefix: -S
      position: 6
  process:
    type: int?
    inputBinding:
      prefix: -p
      position: 7
outputs:
  bowtie2_sam:
    type: File
    outputBinding:
      glob: $(inputs.output)
