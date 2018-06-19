cwlVersion: v1.0
class: Workflow

inputs:
  ## Common input
  nthreads: int

  ## Inputs for download_sra
  repo: string?
  run_ids: string[]

  ## Inputs for fastq-dump
  gzip:
    type: boolean
    default: false

  ## Inputs for star_mapping
  genomeDir: Directory

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
      sraFiles: download-sra/sraFiles
      nthreads: nthreads
      gzip: gzip
    out:
      [fastqFiles]

  star_mapping:
    run: star_mapping.cwl
    in:
      nthreads: nthreads
      genomeDir: genomeDir
      readFilesIn: pfastq-dump/fastqFiles
    out:
      [output_bam]

  samtools_sort:
    run: samtools_sort.cwl
    in:
      input_bam: star_mapping/output_bam
      nthreads: nthreads
    out: [sorted_bamfile]

  cufflinks:
    run: cufflinks.cwl
    in:
      nthreads: nthreads
      annotation: annotation
      input_bam: samtools_sort/sorted_bamfile
    out: [cufflinks_result]
