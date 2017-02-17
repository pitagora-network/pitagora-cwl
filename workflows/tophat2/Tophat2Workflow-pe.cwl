cwlVersion: v1.0
class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

inputs:

  fastq1: File
  fastq2: File
  genome_index: File
  gtf: File
  annotation_file: File

  stringtie_result_file: string

  thread: int

outputs:
  tophat2_result:
    type: File
    outputSource: tophat2/tophat2_bam
  cufflinks_result:
    type:
      type: array
      items: File
    outputSource: cufflinks/cufflinks_result
  stringtie_result:
    type: File
    outputSource: stringtie/stringtie_result

steps:
  tophat2:
    run: tophat2-pe.cwl
    in:
      fq1: fastq1
      fq2: fastq2
      gi: genome_index
      gtf: gtf
      process: thread
    out: [tophat2_bam]
  cufflinks:
    run: cufflinks.cwl
    in:
      annotation: annotation_file
      bam: tophat2/tophat2_bam
      process: thread
    out: [cufflinks_result]
  stringtie:
    run: stringtie.cwl
    in:
      annotation: annotation_file
      bam: tophat2/tophat2_bam
      output: stringtie_result_file
    out: [stringtie_result]
