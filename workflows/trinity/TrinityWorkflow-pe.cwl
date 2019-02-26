cwlVersion: v1.0
class: Workflow

requirements:
  - class: StepInputExpressionRequirement

inputs:

  seq_type: string
  max_memory: string
  fq1: File
  fq2: File
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
    run: trinity-pe.cwl
    in:
      seq_type: seq_type
      max_memory: max_memory
      fq1: fq1
      fq2: fq2
      cpu: thread
      ss_lib_type: ss_lib_type
      min_contig_length: min_contig_length
      no_bowtie: no_bowtie
      output_dir: output_dir
    out: [trinity_results]

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
