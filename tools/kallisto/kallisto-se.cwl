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
      - $(inputs.single_end)
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
  single:
    type: boolean
    inputBinding:
      position: 3
      prefix: --single
  fragment_length:
    type: double
    inputBinding:
      position: 4
      prefix: -l
  standard_deviation:
    type: double
    inputBinding:
      position: 5
      prefix: -s
  bias:
    type: boolean?
    inputBinding:
      position: 6
      prefix: --bias
  bootstrap_samples:
    type: int?
    inputBinding:
      position: 7
      prefix: -b
  seed:
    type: int?
    inputBinding:
      position: 8
      prefix: --seed=
      separate: false
  plain_text:
    type: boolean?
    inputBinding:
      position: 9
      prefix: --plaintext
  fusion:
    type: boolean?
    inputBinding:
      position: 10
      prefix: --fusion
  fr_stranded:
    type: boolean?
    inputBinding:
      position: 11
      prefix: --fr-stranded
  rf_stranded:
    type: boolean?
    inputBinding:
      position: 12
      prefix: --rf-stranded 
  thread:
    type: int
    inputBinding:
      position: 13
      prefix: -t
  pseudo_bam:
    type: boolean?
    inputBinding:
      position: 14
      prefix: --pseudobam
  single_end:
    type: File
    inputBinding:
      position: 15
      valueFrom: $(self.basename)

outputs:
  quant_results:
    type: Directory
    outputBinding:
      glob: $(inputs.quant_out_dir)
