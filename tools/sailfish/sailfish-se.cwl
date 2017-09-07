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
      - $(inputs.unmated)
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
  unmated:
    type: File
    inputBinding:
      position: 4
      prefix: -r
      valueFrom: $(self.basename)
  gene_map:
    type: File?
    inputBinding:
      position: 5
      prefix: -g
#      valueFrom: $(self.basename)
  use_vbopt:
    type: boolean?
    inputBinding:
      position: 6
      prefix: --useVBOpt
  gibbs_samples:
    type: int?
    inputBinding:
      position: 7
      prefix: --numGibbsSamples
  num_bootstrap:
    type: int?
    inputBinding:
      position: 8
      prefix: --numBootstraps
  process:
    type: int?
    inputBinding:
      position: 9
      prefix: -p
outputs:
  quant_results:
    type: Directory
    outputBinding:
      glob: $(inputs.quant_out_dir)
