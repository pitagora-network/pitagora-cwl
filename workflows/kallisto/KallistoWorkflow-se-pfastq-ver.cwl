cwlVersion: v1.0
class: Workflow

requirements:
  - class: StepInputExpressionRequirement

inputs:

  index_file: File
  quant_out_dir: string
  single: boolean
  fragment_length: double
  standard_deviation: double
  bias: boolean?
  boostrap_samples: int?
  seed: int?
  plain_text: boolean?
  fusion: boolean?
  fr_stranded: boolean?
  rf_stranded: boolean?
  thread: int
  pseudo_bam: boolean?

  run_id: string
  read_type: string

outputs:
  pfastq-dump_fq_result:
    type: File
    outputSource: pfastq-dump/dump_fq
  pfastq-dump_version_result:
    type: File
    outputSource: pfastq-dump/pfastq-dump_version
  kallisto_version_stdout_result:
    type: File
    outputSource: kallisto_stdout/kallisto_version_stdout
  kallisto_version_result:
    type: File
    outputSource: kallisto_version/version_output
  quant_result:
    type: Directory
    outputSource: kallisto_quant/quant_results

steps:
  pfastq-dump:
    run: prefetch_pfastq-dump.cwl
    in:
      run_id: run_id
      read_type: read_type
      thread: thread
    out: [dump_fq, pfastq-dump_version]
  kallisto_stdout:
    run: kallisto-version.cwl
    in: []
    out: [kallisto_version_stdout]
  kallisto_version:
    run: ngs-version.cwl
    in:
      infile: kallisto_stdout/kallisto_version_stdout
    out: [version_output]
  kallisto_quant:
    run: kallisto-se.cwl
    in:
      index_file: index_file
      quant_out_dir: quant_out_dir
      single: single
      fragment_length: fragment_length
      standard_deviation: standard_deviation
      bias: bias
      boostrap_samples: boostrap_samples
      seed: seed
      plain_text: plain_text
      fusion: fusion
      fr_stranded: fr_stranded
      rf_stranded: rf_stranded
      thread: thread
      pseudo_bam: pseudo_bam
      fq: pfastq-dump/dump_fq
    out: [quant_results]
