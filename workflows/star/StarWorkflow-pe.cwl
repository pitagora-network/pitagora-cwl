cwlVersion: v1.0
class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

inputs:

  fastq1: File
  fastq2: File
  genome_directory: Directory
  gtf: File
  output_sam_type: string
  output_name_prefix: string
  output_sam_strand_field: string

  annotation_file: File

  stringtie_result_file: string

  thread: int

outputs:
  star_result:
    type: File
    outputSource: star/star_bam
  cufflinks_result:
    type:
      type: array
      items: File
    outputSource: cufflinks/cufflinks_result
  stringtie_result:
    type: File
    outputSource: stringtie/stringtie_result

steps:
  star:
    run: star-pe.cwl
    in:
      fq1: fastq1
      fq2: fastq2
      genome_directory: genome_directory
      gtf: gtf
      out_sam_type: output_sam_type
      out_name_prefix: output_name_prefix
      out_sam_strand_field: output_sam_strand_field
      process: thread
    out: [star_bam]
  cufflinks:
    run: cufflinks.cwl
    in:
      annotation: annotation_file
      bam: star/star_bam
      process: thread
    out: [cufflinks_result]
  stringtie:
    run: stringtie.cwl
    in:
      bam: star/star_bam
      annotation: annotation_file
      output: stringtie_result_file
    out: [stringtie_result]
