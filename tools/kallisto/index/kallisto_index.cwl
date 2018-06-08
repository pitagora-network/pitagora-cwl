cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/kallisto:0.43.1
baseCommand: ["kallisto", "index"]

requirements:
  InitialWorkDirRequirement:
    listing:
      - $(inputs.fasta_file)

inputs:
  index_name:
    type: string
    inputBinding:
      position: 1
      prefix: -i
  kmer_size:
    type: int?
    default: 31
    inputBinding:
      position: 2
      prefix: -k
  make_unique:
    type: boolean?
    default: true
    inputBinding:
      position: 3
      prefix: --make-unique
  fasta_file:
    type: File
    inputBinding:
      position: 4
      valueFrom: $(self.basename)

outputs:
  index_file:
    type: File
    outputBinding:
      glob: $(inputs.index_name)
