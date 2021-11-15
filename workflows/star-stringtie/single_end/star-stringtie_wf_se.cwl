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

  ## Inputs for stringtie
  annotation: File

outputs:
  assemble_output:
    type: File
    outputSource: stringtie_assemble/assemble_output

steps:
  download-sra:
    run: https://raw.githubusercontent.com/pitagora-network/pitagora-cwl/master/tools/download-sra/download-sra.cwl
    in:
      repo: repo
      run_ids: run_ids
    out:
      [sraFiles]

  pfastq-dump:
    run: https://raw.githubusercontent.com/pitagora-network/pitagora-cwl/master/tools/pfastq-dump/pfastq-dump.cwl
    in:
      sraFiles: download-sra/sraFiles
      nthreads: nthreads
      gzip: gzip
    out:
      [fastqFiles]

  star_mapping:
    run: https://raw.githubusercontent.com/pitagora-network/pitagora-cwl/master/tools/star/mapping/single_end/star_mapping_se.cwl
    in:
      nthreads: nthreads
      genomeDir: genomeDir
      fq: pfastq-dump/fastqFiles
    out:
      [output_bam]

  samtools_sort:
    run: https://raw.githubusercontent.com/pitagora-network/pitagora-cwl/master/tools/samtools/sort/samtools_sort.cwl
    in:
      input_bam: star_mapping/output_bam
      nthreads: nthreads
    out: [sorted_bamfile]

  stringtie_assemble:
    run: https://raw.githubusercontent.com/pitagora-network/pitagora-cwl/master/tools/stringtie/assemble/stringtie_assemble.cwl
    in:
      input_bam: samtools_sort/sorted_bamfile
      nthreads: nthreads
      annotation: annotation
    out: [assemble_output]

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
  - https://schema.org/version/latest/schemaorg-current-http.rdf
  - http://edamontology.org/EDAM_1.18.owl
