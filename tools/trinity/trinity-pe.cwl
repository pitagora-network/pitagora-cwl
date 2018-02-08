cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: comics/trinityrnaseq:2.2.0
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.fq1)
      - $(inputs.fq2)
baseCommand: ["Trinity"]

inputs:
  seq_type: 
    type: string
    inputBinding:
      position: 1
      prefix: --seqType
  max_memory:
    type: string
    inputBinding:
      position: 2
      prefix: --max_memory
  fq1:
    type: File
    inputBinding:
      position: 3
      prefix: --left
      valueFrom: $(self.basename)
  fq2:
    type: File
    inputBinding:
      position: 4
      prefix: --right
      valueFrom: $(self.basename)
  cpu:
    type: int?
    inputBinding:
      position: 5
      prefix: --CPU
  ss_lib_type:
    type: string?
    inputBinding:
      position: 6
      prefix: --SS_lib_type
  min_contig_length:
    type: int
    inputBinding:
      position: 7
      prefix: --min_contig_length
  no_bowtie:
    type: boolean?
    inputBinding:
      position: 8
      prefix: --no_bowtie
  output_dir:
    type: string
    inputBinding:
      position: 9
      prefix: --output
outputs:
  trinity_results:
    type: Directory
    outputBinding:
      glob: $(inputs.output_dir)
