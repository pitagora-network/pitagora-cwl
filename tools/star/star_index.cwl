cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/star:2.5.2b
baseCommand: STAR
requirements:
  - class: InlineJavascriptRequirement
inputs:
  run_mode:
    type: string
    inputBinding:
      prefix: --runMode
      position: 1
  genome_directory:
    type: string
    inputBinding:
      prefix: --genomeDir
      position: 2
  out_name_prefix:
    type: string
    inputBinding:
      prefix: --outFileNamePrefix
      position: 3
  genome_fasta_files:
    type: File
    inputBinding:
      prefix: --genomeFastaFiles
      position: 4
outputs:
  result:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*"
