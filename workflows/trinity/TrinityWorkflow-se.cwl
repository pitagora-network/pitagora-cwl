cwlVersion: v1.0
class: Workflow

requirements:
  - class: StepInputExpressionRequirement

inputs:

  seq_type: string
  max_memory: string
  fq: File
  thread: int?
  ss_lib_type: string?
  min_contig_length: int
  no_bowtie: boolean?
  output_dir: string

outputs:
  trinity_version_stdout_result:
    type: File
    outputSource: trinity_stdout/trinity_version_stdout
  trinity_version_result:
    type: File
    outputSource: trinity_version/version_output
  trinity_result:
    type: Directory
    outputSource: trinity/trinity_results

steps:
  trinity_stdout:
    run: trinity-version.cwl
    in: []
    out: [trinity_version_stdout]
  trinity_version:
    run: ngs-version.cwl
    in:
      infile: trinity_stdout/trinity_version_stdout
    out: [version_output]
  trinity:
    run: trinity-se.cwl
    in:
      seq_type: seq_type
      max_memory: max_memory
      fq: fq
      cpu: thread
      ss_lib_type: ss_lib_type
      min_contig_length: min_contig_length
      no_bowtie: no_bowtie
      output_dir: output_dir
    out: [trinity_results]
