cwlVersion: v1.0
class: Workflow

inputs:
  ## Common input
  nthreads: int

  ## Inputs for download_sra
  repo: string?
  run_ids: string[]

  ## Inputs for hisat2_mapping
  hisat2_idx_basedir: Directory
  hisat2_idx_basename: string

  ## Inputs for rsem
  rsem_index_dir: Directory
  rsem_index_prefix: string
  rsem_output_prefix: string

outputs:
  genes_result:
    type: File
    outputSource: rsem-calculate-expression/genes_result
  isoforms_result:
    type: File
    outputSource: rsem-calculate-expression/isoforms_result
  stat:
    type: File
    outputSource: rsem-calculate-expression/stat

steps:
  download-sra:
    run: download-sra.cwl
    in:
      repo: repo
      run_ids: run_ids
    out:
      [sraFiles]

  pfastq-dump:
    run: pfastq-dump.cwl
    in:
      sraFiles: download-sra/sraFiles
      nthreads: nthreads
    out:
      [fastqFiles]

  hisat2_mapping:
    run: hisat2_mapping_se.cwl
    in:
      hisat2_idx_basedir: hisat2_idx_basedir
      hisat2_idx_basename: hisat2_idx_basename
      fq: pfastq-dump/fastqFiles
      nthreads: nthreads
    out:
      [hisat2_sam]

  samtools_sam2bam:
    run: samtools_sam2bam.cwl
    in:
      input_sam: hisat2_mapping/hisat2_sam
    out: [bamfile]

  samtools_sort:
    run: samtools_sort.cwl
    in:
      input_bam: samtools_sam2bam/bamfile
      nthreads: nthreads
    out: [sorted_bamfile]


  rsem-calculate-expression:
    run: rsem-calculate-expression.cwl
    in:
      input_bam: samtools_sort/sorted_bamfile
      rsem_index_dir: rsem_index_dir
      rsem_index_prefix: rsem_index_prefix
      rsem_output_prefix: rsem_output_prefix
    out: [genes_result, isoforms_result, stat]
