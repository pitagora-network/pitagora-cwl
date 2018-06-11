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

  ## Inputs for cufflinks
  annotation: File

outputs:
  cufflinks_result:
    type:
      type: array
      items: File
    outputSource: cufflinks/cufflinks_result

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
      sraFiles: download_sra/sraFiles
      nthreads: nthreads
    out:
      [forward, reverse]

  hisat2_mapping:
    run: hisat2_mapping.cwl
    in:
      hisat2_idx_basedir: hisat2_idx_basedir
      hisat2_idx_basename: hisat2_idx_basename
      fq1: pfastq-dump/forward
      fq2: pfastq-dump/reverse
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

  cufflinks:
    run: cufflinks.cwl
    in:
      nthreads: nthreads
      annotation: annotation
      input_bam: samtools_sort/sorted_bamfile
    out: [cufflinks_result]
