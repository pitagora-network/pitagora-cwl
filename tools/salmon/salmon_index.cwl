cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: combinelab/salmon
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.transcript)
      - $(inputs.index)
baseCommand: ["salmon", "index"]

inputs:
  transcript:
    type: File
    inputBinding:
      position: 1
      prefix: -t
      valueFrom: $(self.basename)
  kmer_length:
    type: int?
    inputBinding:
      position: 2
      prefix: -k
  index:
    type: Directory
    inputBinding:
      position: 3
      prefix: -i
      valueFrom: $(self.basename)
  process:
    type: int?
    inputBinding:
      position: 4
      prefix: -p
  genecode:
    type: boolean?
    inputBinding:
      position: 5
      prefix: --genecode
  sasamp:
    type: int?
    inputBinding:
      position: 6
      prefix: -s
  perfect_hash:
    type: boolean?
    inputBinding:
      position: 7
      prefix: --perfectHash
outputs:
  index_results:
    type: Directory
    outputBinding:
      glob: $(inputs.index.basename)
