cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/kallisto
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.index_file)
      - $(inputs.mates1)
      - $(inputs.mates2)
baseCommand: ["kallisto", "quant"]

inputs:
  index_file:
    type: File
    inputBinding:
      position: 1
      prefix: -i
      valueFrom: $(self.basename)
  quant_out_dir:
    type: string
    inputBinding:
      position: 2
      prefix: -o
  fragment_length:
    type: double
    inputBinding:
      position: 3
      prefix: -l
  standard_deviation:
    type: double
    inputBinding:
      position: 4
      prefix: -s
  bias:
    type: boolean?
    inputBinding:
      position: 5
      prefix: --bias
  bootstrap_samples:
    type: int?
    inputBinding:
      position: 6
      prefix: -b
  seed:
    type: int?
    inputBinding:
      position: 7
      prefix: --seed=
      separate: false
  plain_text:
    type: boolean?
    inputBinding:
      position: 8
      prefix: --plaintext
  fusion:
    type: boolean?
    inputBinding:
      position: 9
      prefix: --fusion
  fr_stranded:
    type: boolean?
    inputBinding:
      position: 10
      prefix: --fr-stranded
  rf_stranded:
    type: boolean?
    inputBinding:
      position: 11
      prefix: --rf-stranded 
  thread:
    type: int
    inputBinding:
      position: 12
      prefix: -t
  pseudo_bam:
    type: boolean?
    inputBinding:
      position: 13
      prefix: --pseudobam
  mates1:
    type: File
    inputBinding:
      position: 14
      valueFrom: $(self.basename)
  mates2:
    type: File
    inputBinding:
      position: 15
      valueFrom: $(self.basename)

outputs:
  quant_results:
    type: Directory
    outputBinding:
      glob: $(inputs.quant_out_dir)
