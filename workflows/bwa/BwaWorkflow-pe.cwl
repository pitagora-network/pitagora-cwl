cwlVersion: v1.0
class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement

inputs:

  # BWA parameters
  fastq1: File
  fastq2: File
  genome_index: File
  mem: boolean
  mark_shorter_split_hits: boolean
  read_group_header_line: string
  thread: int

  # samtools-view parameters
  bs_option: boolean
  samtools-view_result_file: string

  # samtools-sort parameters
  samtools-sort_result_file: string

  # samtools-index parameters
  samtools-index_result_file: string

  # picard-markduplicates parameters
  dupout: string
  metout: string

  # picard-reordersam parameters
  reference: File
  reorder: string

  # samtools-index parameters
  samtools-index_reorder_indexbam: string

  # gatk-realignertargetcreator parameters
  realign_program: string
  gatk_reference: File
  realigner_output: string

  # gatk-indelrealigner parameters
  indel_program: string
  indel_output: string

  # picard-fixmateinformation parameters
  fixmateinfo_output: string
  sort: string
  validation: string

  # samtools-index parameters
  samtools-index_fixmate_indexbam: string

  # gatk-baserecalibrator parameters
  base_program: string
  table_output: string
  knownsite: File
  skipaic: boolean

  # gatk-printreads parameters
  print_program: string
  print_output: string

  # gatk-haplotypecaller parameters
  haplo_program: string
  vcf_output: string

  # annovar parameters
  annovar_reference: Directory
  reference_version: string
  annovar_output: string
  annovar_remove: boolean
  annovar_protocol: string
  annovar_operation: string
  annovar_nastring: string
  annovar_vcfinput: boolean

outputs:
  bwa_result:
    type: File
    outputSource: bwa/tmpsam
  trim_result:
    type: File
    outputSource: trim/sam
  samtools-view_result:
    type: File
    outputSource: samtools-view/samtools-view_bam
  samtools-sort_result:
    type: File
    outputSource: samtools-sort/samtools-sort_sortbam
  samtools-index_result:
    type: File
    outputSource: samtools-index/samtools-index_indexbam
  dupread_result:
    type: File
    outputSource: picard-markduplicates/dupread
  metrics_result:
    type: File
    outputSource: picard-markduplicates/metrics
  reordersam_result:
    type: File
    outputSource: picard-reordersam/reorderres
  reorder_index_result:
    type: File
    outputSource: samtools-index-for-reorder/samtools-index_indexbam
  gatk_aligner_result:
    type: File
    outputSource: gatk-realigner/interval
  gatk_indel_bam_result:
    type: File
    outputSource: gatk-indel/realign
  gatk_indel_bai_result:
    type: File
    outputSource: gatk-indel/realignbai
  picard_fixmate_bam_result:
    type: File
    outputSource: picard-fixmate/fix
  samtools_index_result:
    type: File
    outputSource: samtools-index-for-fixmate/samtools-index_indexbam
  gatk_baserecal_result:
    type: File
    outputSource: gatk-baserecal/table
  gatk_printreads_bam_result:
    type: File
    outputSource: gatk-printreads/print
  gatk_printreads_bai_result:
    type: File
    outputSource: gatk-printreads/printbai
  gatk_haplo_result:
    type: File
    outputSource: gatk-haplo/vcf
  gatk_haplo_index_result:
    type: File
    outputSource: gatk-haplo/vcfidx
  annovar_result:
    type:
      type: array
      items: File
    outputSource: annovar/annovar_results

steps:
  bwa:
    run: bwa-pe.cwl
    in:
      fq1: fastq1
      fq2: fastq2
      genome_index: genome_index
      mem: mem
      mark_shorter_split_hits: mark_shorter_split_hits
      read_group_header_line: read_group_header_line
      process: thread
    out: [tmpsam]
  trim:
    run: grep.cwl
    in:
      tmpoutput: bwa/tmpsam
    out: [sam]
  samtools-view:
    run: samtools-view.cwl
    in:
      bs: bs_option
      bam: samtools-view_result_file
      sam: trim/sam
    out: [samtools-view_bam]
  samtools-sort:
    run: samtools-sort.cwl
    in:
      bam: samtools-view/samtools-view_bam
      sortbam: samtools-sort_result_file
    out: [samtools-sort_sortbam]
  samtools-index:
    run: samtools-index.cwl
    in:
      sortbam: samtools-sort/samtools-sort_sortbam
      indexbam: samtools-index_result_file
    out: [samtools-index_indexbam]
  picard-markduplicates:
    run: picard-markduplicates.cwl
    in:
      bam: samtools-sort/samtools-sort_sortbam
      output: dupout
      metout: metout
    out: [dupread, metrics]
  picard-reordersam:
    run: picard-reordersam.cwl
    in:
      dupread: picard-markduplicates/dupread
      reference: reference
      output: reorder
    out: [reorderres]
  samtools-index-for-reorder:
    run: samtools-index.cwl
    in:
      sortbam: picard-reordersam/reorderres
      indexbam: samtools-index_reorder_indexbam
    out: [samtools-index_indexbam]
  gatk-realigner:
    run: gatk.cwl
    in:
      program: realign_program
      reference: gatk_reference
      bam: picard-reordersam/reorderres
      bai: samtools-index-for-reorder/samtools-index_indexbam
      output: realigner_output
    out: [interval]
  gatk-indel:
    run: gatk.cwl
    in:
      program: indel_program
      reference: gatk_reference
      bam: picard-reordersam/reorderres
      bai: samtools-index-for-reorder/samtools-index_indexbam
      interval: gatk-realigner/interval
      output: indel_output
    out: [realign, realignbai]
  picard-fixmate:
    run: picard-fixmateinformation.cwl
    in:
      bam: gatk-indel/realign
      bai: gatk-indel/realignbai
      sort: sort
      validation: validation
      output: fixmateinfo_output
    out: [fix]
  samtools-index-for-fixmate:
    run: samtools-index.cwl
    in:
      sortbam: picard-fixmate/fix
      indexbam: samtools-index_fixmate_indexbam
    out: [samtools-index_indexbam]
  gatk-baserecal:
    run: gatk.cwl
    in:
      program: base_program
      reference: gatk_reference
      knownsite: knownsite
      bam: picard-fixmate/fix
      bai: samtools-index-for-fixmate/samtools-index_indexbam
      output: table_output
      skipaic: skipaic
    out: [table]
  gatk-printreads:
    run: gatk.cwl
    in:
      program: print_program
      reference: gatk_reference
      bam: picard-fixmate/fix
      bai: samtools-index-for-fixmate/samtools-index_indexbam
      base_quality_score_recalib: gatk-baserecal/table
      output: print_output
    out: [print, printbai]
  gatk-haplo:
    run: gatk.cwl
    in:
      program: haplo_program
      reference: gatk_reference
      bam: gatk-printreads/print
      bai: gatk-printreads/printbai
      output: vcf_output
    out: [vcf, vcfidx]
  annovar:
    run: annovar.cwl
    in:
      vcf: gatk-haplo/vcf
      vcfidx: gatk-haplo/vcfidx
      reference: annovar_reference
      version: reference_version
      output: annovar_output
      remove: annovar_remove
      protocol: annovar_protocol
      operation: annovar_operation
      nastring: annovar_nastring
      vcfinput: annovar_vcfinput
    out: [annovar_results]
