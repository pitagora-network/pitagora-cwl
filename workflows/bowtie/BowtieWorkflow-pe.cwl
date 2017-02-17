cwlVersion: v1.0
class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

inputs:

  fastq1: File
  fastq2: File
  all_alignment: boolean
  reference: File
  max_insert_size: int
  override_offrate: int
  max_ram_mb: int
  sam: string

  bs_option: boolean
  samtools-view_result_file: string

  thread: int

outputs:
  bowtie_result:
    type: File
    outputSource: bowtie/bowtie_sam
  samtools-view_result:
    type: File
    outputSource: samtools-view/samtools-view_bam
  express_result:
    type:
      type: array
      items: File
    outputSource: express/express_result

steps:
  bowtie:
    run: bowtie-pe.cwl
    in:
      fq1: fastq1
      fq2: fastq2
      reference: reference
      all_alignment: all_alignment
      max_insert_size: max_insert_size
      override_offrate: override_offrate
      max_ram_mb: max_ram_mb
      process: thread
      sam: sam
    out: [bowtie_sam]
  samtools-view:
    run: samtools-view.cwl
    in:
      bs: bs_option
      bam: samtools-view_result_file
      sam: bowtie/bowtie_sam
    out: [samtools-view_bam]
  express:
    run: express.cwl
    in:
      bam: samtools-view/samtools-view_bam
      reference: reference
    out: [express_result]
