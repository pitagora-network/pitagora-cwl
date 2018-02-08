cwlVersion: v1.0
class: Workflow

requirements:
  - class: StepInputExpressionRequirement

inputs:

  index_dir: Directory
  lib_type: string
  quant_out_dir: string
  fq1: File
  fq2: File
  allow_orphans: boolean?
  seq_bias: boolean?
  gc_bias: boolean?
  incompat_prior: double?
#  gene_map: File?
  process: int?
#  write_mappings: File?
  meta: boolean?
  dump_eq: boolean?
  dump_eq_weights: boolean?
  use_vbopt: boolean?
  gibbs_samples: int?
  num_bootstrap: int?
  bias_speed_samp: int?
  write_unmapped_names: boolean?

outputs:
  salmon_version_stderr_result:
    type: File
    outputSource: salmon_stderr/salmon_version_stderr
  salmon_version_result:
    type: File
    outputSource: salmon_version/version_output
  quant_result:
    type: Directory
    outputSource: salmon_quant/quant_results

steps:
  salmon_stderr:
    run: salmon-version.cwl
    in: []
    out: [salmon_version_stderr]
  salmon_version:
    run: ngs-version.cwl
    in:
      infile: salmon_stderr/salmon_version_stderr
    out: [version_output]
  salmon_quant:
    run: salmon-pe.cwl
    in:
      index_dir: index_dir
      lib_type: lib_type
      quant_out_dir: quant_out_dir
      fq1: fq1
      fq2: fq2
      allow_orphans: allow_orphans
      seq_bias: seq_bias
      gc_bias: gc_bias
      incompat_prior: incompat_prior
#      gene_map: gene_map
      process: process
#      write_mappings: write_mappings
      meta: meta
      dump_eq: dump_eq
      dump_eq_weights: dump_eq_weights
      use_vbopt: use_vbopt
      gibbs_samples: gibbs_samples
      num_bootstrap: num_bootstrap
      bias_speed_samp: bias_speed_samp
      write_unmapped_names: write_unmapped_names
    out: [quant_results]
