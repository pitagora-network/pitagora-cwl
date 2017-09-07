cwlVersion: v1.0
class: Workflow

requirements:
  - class: StepInputExpressionRequirement

inputs:

  index_dir: Directory
  lib_type: string
  quant_out_dir: string
  mates1: File
  mates2: File
#  gene_map: File?
  use_vbopt: boolean?
  num_bootstrap: int?
  gibbs_samples: int?

  process: int?

outputs:
  sailfish_version_stderr_result:
    type: File
    outputSource: sailfish_stderr/sailfish_version_stderr
  sailfish_version_result:
    type: File
    outputSource: sailfish_version/version_output
  quant_result:
    type: Directory
    outputSource: sailfish_quant/quant_results

steps:
  sailfish_stderr:
    run: sailfish-version.cwl
    in: []
    out: [sailfish_version_stderr]
  sailfish_version:
    run: ngs-version.cwl
    in:
      infile: sailfish_stderr/sailfish_version_stderr
    out: [version_output]
  sailfish_quant:
    run: sailfish-pe.cwl
    in:
      index_dir: index_dir
      lib_type: lib_type
      mates1: mates1
      mates2: mates2
      quant_out_dir: quant_out_dir
#      gene_map: gene_map
      use_vbopt: use_vbopt
      gibbs_samples: gibbs_samples
      num_bootstrap: num_bootstrap
      process: process
    out: [quant_results]
