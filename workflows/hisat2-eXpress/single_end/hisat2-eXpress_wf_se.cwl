cwlVersion: v1.0
class: Workflow

inputs:
  ## Common input
  nthreads: int

  ## Inputs for download-sra
  repo: string?
  run_ids: string[]

  ## Inputs for hisat2_mapping
  hisat2_idx_basedir: Directory
  hisat2_idx_basename: string

  ## Inputs for eXpress
  target_fasta: File

outputs:
  express_result:
    type:
      type: array
      items: File
    outputSource: express/express_result

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
    out: [sorted_bamfile]

  express:
    run: eXpress.cwl
    in:
      input_bam: samtools_sort/sorted_bamfile
      target_fasta: target_fasta
    out: [express_result]
