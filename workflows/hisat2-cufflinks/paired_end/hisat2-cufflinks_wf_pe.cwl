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
    out:
      [forward, reverse]

  hisat2_mapping:
    run: hisat2_mapping_pe.cwl
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
