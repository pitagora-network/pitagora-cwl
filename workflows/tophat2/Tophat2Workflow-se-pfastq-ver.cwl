cwlVersion: v1.0
class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

inputs:

  run_id: string
  read_type: string

  genome_index: File
  gtf: File
  annotation_file: File

  stringtie_result_file: string

  thread: int?

outputs:
  pfastq-dump_fq_result:
    type: File
    outputSource: pfastq-dump/dump_fq
  pfastq-dump_version_result:
    type: File
    outputSource: pfastq-dump/pfastq-dump_version
  tophat2_version_stdout_result:
    type: File
    outputSource: tophat2_stdout/tophat2_version_stdout
  tophat2_version_result:
    type: File
    outputSource: tophat2_version/version_output
  tophat2_result:
    type: File
    outputSource: tophat2/tophat2_bam
  cufflinks_version_stderr_result:
    type: File
    outputSource: cufflinks_stderr/cufflinks_version_stderr
  cufflinks_version_result:
    type: File
    outputSource: cufflinks_version/version_output
  cufflinks_result:
    type:
      type: array
      items: File
    outputSource: cufflinks/cufflinks_result
  stringtie_version_stdout_result:
    type: File
    outputSource: stringtie_stdout/stringtie_version_stdout
  stringtie_version_result:
    type: File
    outputSource: stringtie_version/version_output
  stringtie_result:
    type: File
    outputSource: stringtie/stringtie_result

steps:
  pfastq-dump:
    run: prefetch_pfastq-dump.cwl
    in:
      run_id: run_id
      read_type: read_type
      thread: thread
    out: [dump_fq, pfastq-dump_version]
  tophat2_stdout:
    run: tophat2-version.cwl
    in: []
    out: [tophat2_version_stdout]
  tophat2_version:
    run: ngs-version.cwl
    in:
      infile: tophat2_stdout/tophat2_version_stdout
    out: [version_output]
  tophat2:
    run: tophat2-se.cwl
    in:
      fq: pfastq-dump/dump_fq
      gi: genome_index
      gtf: gtf
      process: thread
    out: [tophat2_bam]
  cufflinks_stderr:
    run: cufflinks-version.cwl
    in: []
    out: [cufflinks_version_stderr]
  cufflinks_version:
    run: ngs-version.cwl
    in:
      infile: cufflinks_stderr/cufflinks_version_stderr
    out: [version_output]
  cufflinks:
    run: cufflinks.cwl
    in:
      annotation: annotation_file
      bam: tophat2/tophat2_bam
      process: thread
    out: [cufflinks_result]
  stringtie_stdout:
    run: stringtie-version.cwl
    in: []
    out: [stringtie_version_stdout]
  stringtie_version:
    run: ngs-version.cwl
    in:
      infile: stringtie_stdout/stringtie_version_stdout
    out: [version_output]
  stringtie:
    run: stringtie.cwl
    in:
      annotation: annotation_file
      bam: tophat2/tophat2_bam
      output: stringtie_result_file
    out: [stringtie_result]

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
