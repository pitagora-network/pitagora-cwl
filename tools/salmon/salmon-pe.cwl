cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: combinelab/salmon
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.index_dir)
      - $(inputs.mates1)
      - $(inputs.mates2)
#      - $(inputs.gene_map)
#      - $(inputs.write_mappings)
baseCommand: ["salmon", "quant"]

inputs:
  index_dir:
    type: Directory
    inputBinding:
      position: 1
      prefix: -i
      valueFrom: $(self.basename)
  lib_type:
    type: string
    inputBinding:
      position: 2 
      prefix: -l
  quant_out_dir:
    type: string
    inputBinding:
      position: 3
      prefix: -o
  mates1:
    type: File
    inputBinding:
      position: 4
      prefix: "-1"
      valueFrom: $(self.basename)
  mates2:
    type: File
    inputBinding:
      position: 5
      prefix: "-2"
      valueFrom: $(self.basename)
  allow_orphans:
    type: boolean?
    inputBinding:
      position: 6
      prefix: --allowOrphans
  seq_bias:
    type: boolean?
    inputBinding:
      position: 7
      prefix: --seqBias
  gc_bias:
    type: boolean?
    inputBinding:
      position: 8
      prefix: --gcBias
  incompat_prior:
    type: double?
    inputBinding:
      position: 9
      prefix: --incompatPrior
  gene_map:
    type: File?
    inputBinding:
      position: 10
      prefix: -g
#      valueFrom: $(self.basename)
  process:
    type: int?
    inputBinding:
      position: 11
      prefix: -p
  write_mappings:
    type: File?
    inputBinding:
      position: 12
      prefix: --writeMappings=
      separate: false
#      valueFrom: $(self.basename)
  meta:
    type: boolean?
    inputBinding:
      position: 13
      prefix: --meta
  dump_eq:
    type: boolean?
    inputBinding:
      position: 14
      prefix: --dumpEq
  dump_eq_weights:
    type: boolean?
    inputBinding:
      position: 15
      prefix: -d
  use_vbopt:
    type: boolean?
    inputBinding:
      position: 16
      prefix: --useVBOpt
  gibbs_samples:
    type: int?
    inputBinding:
      position: 17
      prefix: --numGibbsSamples
  num_bootstrap:
    type: int?
    inputBinding:
      position: 18
      prefix: --numBootstraps
  bias_speed_samp:
    type: int?
    inputBinding:
      position: 19
      prefix: --biasSpeedSamp
  write_unmapped_names:
    type: boolean?
    inputBinding:
      position: 20
      prefix: --writeUnmappedNames

outputs:
  quant_results:
    type: Directory
    outputBinding:
      glob: $(inputs.quant_out_dir)
