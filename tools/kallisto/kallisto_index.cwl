cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/kallisto:0.43.1
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.fasta_file)
baseCommand: ["kallisto", "index"]

inputs:
  index_file:
    type: string
    inputBinding:
      position: 1
      prefix: -i
  kmer_size:
    type: int?
    inputBinding:
      position: 2
      prefix: -k
  make_unique:
    type: boolean?
    inputBinding:
      position: 3
      prefix: --make-unique
  fasta_file:
    type: File
    inputBinding:
      position: 4
      valueFrom: $(self.basename)
outputs:
  index_results:
    type: File
    outputBinding:
      glob: $(inputs.index_file)
