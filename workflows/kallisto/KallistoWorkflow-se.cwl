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
  single_end: File

outputs:
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
      single_end: single_end
    out: [quant_results]
