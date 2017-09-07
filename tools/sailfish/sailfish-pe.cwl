cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/sailfish
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.index_dir)
      - $(inputs.mates1)
      - $(inputs.mates2)
#      - $(inputs.gene_map)
baseCommand: ["sailfish", "quant"]

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
  gene_map:
    type: File?
    inputBinding:
      position: 6
      prefix: -g
#      valueFrom: $(self.basename)
  use_vbopt:
    type: boolean?
    inputBinding:
      position: 7
      prefix: --useVBOpt
  gibbs_samples:
    type: int?
    inputBinding:
      position: 8
      prefix: --numGibbsSamples
  num_bootstrap:
    type: int?
    inputBinding:
      position: 9
      prefix: --numBootstraps
  process:
    type: int?
    inputBinding:
      position: 10
      prefix: -p

outputs:
  quant_results:
    type: Directory
    outputBinding:
      glob: $(inputs.quant_out_dir)
