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

  allow_orphans: boolean?
  seq_bias: boolean?
  gc_bias: boolean?
  incompat_prior: double?
#  gene_map: File?
  thread: int?
#  write_mappings: File?
  meta: boolean?
  dump_eq: boolean?
  dump_eq_weights: boolean?
  fld_mean: int?
  fld_sd: int?
  use_vbopt: boolean?
  gibbs_samples: int?
  num_bootstrap: int?
  bias_speed_samp: int?
  write_unmapped_names: boolean?

outputs:
  pfastq-dump_fq_result:
    type: File
    outputSource: pfastq-dump/dump_fq
  pfastq-dump_version_result:
    type: File
    outputSource: pfastq-dump/pfastq-dump_version
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
  pfastq-dump:
    run: prefetch_pfastq-dump.cwl
    in:
      run_id: run_id
      read_type: read_type
      thread: thread
    out: [dump_fq, pfastq-dump_version]
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
    run: salmon-se.cwl
    in:
      index_dir: index_dir
      lib_type: lib_type
      quant_out_dir: quant_out_dir
      fq: pfastq-dump/dump_fq
      allow_orphans: allow_orphans
      seq_bias: seq_bias
      gc_bias: gc_bias
      incompat_prior: incompat_prior
#      gene_map: gene_map
      process: thread
#      write_mappings: write_mappings
      meta: meta
      dump_eq: dump_eq
      dump_eq_weights: dump_eq_weights
      fld_mean: fld_mean
      fld_sd: fld_sd
      use_vbopt: use_vbopt
      gibbs_samples: gibbs_samples
      num_bootstrap: num_bootstrap
      bias_speed_samp: bias_speed_samp
      write_unmapped_names: write_unmapped_names
    out: [quant_results]
