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
      [forward, reverse]

  star_mapping:
    run: star_mapping_pe.cwl
    in:
      nthreads: nthreads
      genomeDir: genomeDir
      fq1: pfastq-dump/forward
      fq2: pfastq-dump/reverse
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

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl
s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0003-3777-5945
    s:email: mailto:inutano@gmail.com
    s:name: Tazro Ohta

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
