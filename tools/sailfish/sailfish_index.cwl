cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/sailfish:0.10.0
requirements:
  - class: InlineJavascriptRequirement
baseCommand: ["sailfish", "index"]

inputs:
  transcript:
    type: File
    inputBinding:
      position: 1
      prefix: -t
  kmer_size:
    type: int?
    inputBinding:
      position: 2
      prefix: -k
  index_out_dir:
    type: string
    inputBinding:
      position: 3
      prefix: -o
  process:
    type: int?
    inputBinding:
      position: 4
      prefix: -p
  force:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -f
  perfect_hash:
    type: boolean?
    inputBinding:
      position: 6
      prefix: --perfectHash
outputs:
  index_results:
    type: Directory
    outputBinding:
      glob: $(inputs.index_out_dir)
