cwlVersion: v1.0
class: Workflow

requirements:
  - class: StepInputExpressionRequirement

inputs:

  index_dir: Directory
  lib_type: string
  quant_out_dir: string

  run_id: string
  read_type: string

#  gene_map: File?
  use_vbopt: boolean?
  num_bootstrap: int?
  gibbs_samples: int?

  thread: int?

outputs:
  pfastq-dump_fq1_result:
    type: File
    outputSource: pfastq-dump/dump_fq1
  pfastq-dump_fq2_result:
    type: File
    outputSource: pfastq-dump/dump_fq2
  pfastq-dump_version_result:
    type: File
    outputSource: pfastq-dump/pfastq-dump_version
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
  pfastq-dump:
    run: prefetch_pfastq-dump.cwl
    in:
      run_id: run_id
      read_type: read_type
      thread: thread
    out: [dump_fq1, dump_fq2, pfastq-dump_version]
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
      fq1: pfastq-dump/dump_fq1
      fq2: pfastq-dump/dump_fq2
      quant_out_dir: quant_out_dir
#      gene_map: gene_map
      use_vbopt: use_vbopt
      gibbs_samples: gibbs_samples
      num_bootstrap: num_bootstrap
      process: thread
    out: [quant_results]
