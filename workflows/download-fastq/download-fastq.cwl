cwlVersion: v1.0
class: Workflow
label: "Download sequence data from Sequence Read Archive and dump to FASTQ file"
doc: "input variable repo should be one of ncbi or ebi"

inputs:
  run_ids:
    type: string[]
    label: "list of SRA Run ID e.g. SRR1274307"
  nthreads:
    type: int?
    default: 4
    label: "Optional: number of threads to be used by parallel fastq-dump"
  repo:
    type: string?
    default: "ebi"
    label: "Optional: repository to be used. ncbi or ebi"

outputs:
  fastq_files:
    type: File[]
    outputSource: pfastq_dump/fastqFiles

steps:
  download_sra:
    run: https://github.com/pitagora-network/pitagora-cwl/raw/master/tools/download-sra/download-sra.cwl
    in:
      repo: repo
      run_ids: run_ids
    out:
      [sraFiles]
  pfastq_dump:
    run: https://github.com/pitagora-network/pitagora-cwl/raw/master/tools/pfastq-dump/pfastq-dump-multi.cwl
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
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
