cwlVersion: v1.0
class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement

inputs:

  run_id: string
  read_type: string

  # LASTal parameters
  gap_alignment_min_score: int
  genome_index: File
  input_format: int
  thread: int?

  # maf-convert parameters
  format_type: string
  dictionary: File

  # samtools-view parameters
  bs_option: boolean
  samtools-view_result_file: string

  # picard-addorreplacereadgroups parameters
  modbam: string
  rgid: string
  rglb: string
  rgpl: string
  rgpu: string
  rgsm: string

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
  pfastq-dump_fq_result:
    type: File
    outputSource: pfastq-dump/dump_fq
  pfastq-dump_version_result:
    type: File
    outputSource: pfastq-dump/pfastq-dump_version
  last_version_stdout_result:
    type: File
    outputSource: last_stdout/last_version_stdout
  last_version_result:
    type: File
    outputSource: last_version/version_output
  lastal_result:
    type: File
    outputSource: lastal/maf
  lastsplit_result:
    type: File
    outputSource: lastsplit/splitmaf
  mafconvert_result:
    type: File
    outputSource: mafconvert/sam
  trim_result:
    type: File
    outputSource: trim/sam
  samtools_version_stderr_result:
    type: File
    outputSource: samtools_stderr/samtools_version_stderr
  samtools_version_result:
    type: File
    outputSource: samtools_version/version_output
  samtools-view_result:
    type: File
    outputSource: samtools-view/samtools-view_bam
  picard_version_stderr_result:
    type: File
    outputSource: picard_stderr/picard_version_stderr
  picard_version_result:
    type: File
    outputSource: picard_version/version_output
  picard-addorreplacereadgroups_result:
    type: File
    outputSource: picard-addorreplacereadgroups/fix
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
  gatk_version_stdout_result:
    type: File
    outputSource: gatk_stdout/gatk_version_stdout
  gatk_version_result:
    type: File
    outputSource: gatk_version/version_output
  gatk_aligner_result:
    type: File
    outputSource: gatk-realigner/interval_res
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
  annovar_version_stdout_result:
    type: File
    outputSource: annovar_stdout/annovar_version_stdout
  annovar_version_result:
    type: File
    outputSource: annovar_version/version_output
  annovar_result:
    type:
      type: array
      items: File
    outputSource: annovar/annovar_results

steps:
  pfastq-dump:
    run: prefetch_pfastq-dump.cwl
    in:
      run_id: run_id
      read_type: read_type
      thread: thread
    out: [dump_fq, pfastq-dump_version]
  last_stdout:
    run: last-version.cwl
    in: []
    out: [last_version_stdout]
  last_version:
    run: ngs-version.cwl
    in:
      infile: last_stdout/last_version_stdout
    out: [version_output]
  lastal:
    run: lastal.cwl
    in:
      fq: pfastq-dump/dump_fq
      genome_index: genome_index
      gap_alignment_min_score: gap_alignment_min_score
      input_format: input_format
      process: thread
    out: [maf]
  lastsplit:
    run: last-split.cwl
    in:
      maf: lastal/maf
    out: [splitmaf]
  mafconvert:
    run: maf-convert.cwl
    in:
      maf1: lastsplit/splitmaf
      format_type: format_type
      dictionary: dictionary
    out: [sam]
  trim:
    run: grep.cwl
    in:
      tmpoutput: mafconvert/sam
    out: [sam]
  samtools_stderr:
    run: samtools-version.cwl
    in: []
    out: [samtools_version_stderr]
  samtools_version:
    run: ngs-version.cwl
    in:
      infile: samtools_stderr/samtools_version_stderr
    out: [version_output]
  samtools-view:
    run: samtools-view.cwl
    in:
      bs: bs_option
      bam: samtools-view_result_file
      sam: trim/sam
    out: [samtools-view_bam]
  picard_stderr:
    run: picard-version.cwl
    in: []
    out: [picard_version_stderr]
  picard_version:
    run: ngs-version.cwl
    in:
      infile: picard_stderr/picard_version_stderr
    out: [version_output]
  picard-addorreplacereadgroups:
    run: picard-addorreplacereadgroups.cwl
    in:
      bam: samtools-view/samtools-view_bam
      output: modbam
      rgid: rgid
      rglb: rglb
      rgpl: rgpl
      rgpu: rgpu
      rgsm: rgsm
    out: [fix]
  samtools-sort:
    run: samtools-sort.cwl
    in:
      bam: picard-addorreplacereadgroups/fix
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
  gatk_stdout:
    run: gatk-version.cwl
    in: []
    out: [gatk_version_stdout]
  gatk_version:
    run: ngs-version.cwl
    in:
      infile: gatk_stdout/gatk_version_stdout
    out: [version_output]
  gatk-realigner:
    run: gatk.cwl
    in:
      program: realign_program
      reference: gatk_reference
      bam: picard-reordersam/reorderres
      bai: samtools-index-for-reorder/samtools-index_indexbam
      output: realigner_output
    out: [interval_res]
  gatk-indel:
    run: gatk.cwl
    in:
      program: indel_program
      reference: gatk_reference
      bam: picard-reordersam/reorderres
      bai: samtools-index-for-reorder/samtools-index_indexbam
      interval: gatk-realigner/interval_res
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
  annovar_stdout:
    run: annovar-version.cwl
    in: []
    out: [annovar_version_stdout]
  annovar_version:
    run: ngs-version.cwl
    in:
      infile: annovar_stdout/annovar_version_stdout
    out: [version_output]
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

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
