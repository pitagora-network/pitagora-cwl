cwlVersion: v1.0
class: Workflow
label: "Download sequence data from Sequence Read Archive and dump to FASTQ file"
doc: "input variable repo should be one of ncbi or ebi"

inputs:
  run_id:
    type: string
    label: "A SRA Run ID e.g. SRR1274307"
    doc: "A SRA Run ID e.g. SRR1274307"
  nthreads:
    type: int?
    default: 4
    label: "Optional: number of threads to be used by fasterq-dump (default: 4)"
    doc: "Optional: number of threads to be used by fasterq-dump (default: 4)"
  repo:
    type: string?
    default: "ebi"
    label: "Optional: repository to be used. ncbi or ebi"
    doc: "Optional: repository to be used. ncbi or ebi"

outputs:
  fastq_files:
    type: File[]
    outputSource: fasterq_dump/fastqFiles

steps:
  download_sra:
    run: ../../tools/download-sra/download-sra.cwl
    in:
      repo: repo
      run_ids: run_id
    out:
      [sraFiles]
  fasterq_dump:
    run: ../../tools/fasterq-dump/fasterq-dump.cwl
    in:
      sraFiles: download_sra/sraFiles
      nthreads: nthreads
    out:
      [fastqFiles]

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl

$schemas:
  - https://schema.org/version/latest/schemaorg-current-http.rdf
  - http://edamontology.org/EDAM_1.18.owl
