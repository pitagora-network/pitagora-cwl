cwlVersion: v1.0
class: Workflow

inputs:
  ## Common input
  nthreads: int

  ## Inputs for download_sra
  repo: string?
  run_ids: string[]

  ## Inputs for star_mapping
  genomeDir: Directory

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
      sraFiles: download_sra/sraFiles
      nthreads: nthreads
    out:
      [forward, reverse]

  star_mapping:
    run: star_mapping.cwl
    in:
      nthreads: nthreads
      genomeDir: genomeDir
      readFilesIn: [pfastq-dump/forward, pfastq-dump/reverse]
    out:
      [output_bam]

  samtools_sort:
    run: samtools_sort.cwl
    in:
      input_bam: star_mapping/output_bam
      nthreads: nthreads
    out: [sorted_bamfile]

  express
    run: eXpress.cwl
    in:
      input_bam: samtools_sort/sorted_bamfile
      target_fasta: target_fasta
    out: [express_result]

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
