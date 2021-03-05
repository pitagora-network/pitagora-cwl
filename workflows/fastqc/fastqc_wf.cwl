cwlVersion: v1.0
class: Workflow
label: "Download sequence data from Sequence Read Archive and perform FastQC"
doc: "Download sequence data from Sequence Read Archive and perform FastQC. Run download-sra to get .sra file, convert to FASTQ file by pfastq-dump, then perform FastQC."

inputs:
  nthreads: int
  run_ids: string[]
  repo: string?

outputs:
  fastq_files:
    type: File[]
    outputSource: pfastq_dump/fastqFiles
  fastqc_result:
    type: File[]
    outputSource: fastqc/fastqc_result
  fastqc_summary_ttl:
    type: File[]
    outputSource: fastqc-util-ttl/fastqc_summary
  fastqc_summary_tsv:
    type: File[]
    outputSource: fastqc-util-tsv/fastqc_summary

steps:
  download_sra:
    run: https://github.com/pitagora-network/pitagora-cwl/raw/master/tools/download-sra/download-sra.cwl
    in:
      repo: repo
      run_ids: run_ids
    out:
      [sraFiles]
  pfastq_dump:
    run: https://github.com/pitagora-network/pitagora-cwl/raw/master/tools/pfastq-dump/pfastq-dump.cwl
    in:
      sraFiles: download_sra/sraFiles
      nthreads: nthreads
    out:
      [fastqFiles]
  fastqc:
    run: https://github.com/pitagora-network/pitagora-cwl/raw/master/tools/fastqc/fastqc.cwl
    in:
      seqfile: pfastq_dump/fastqFiles
      nthreads: nthreads
    out:
      [fastqc_result]
  fastqc-util-tsv:
    run: https://github.com/pitagora-network/pitagora-cwl/raw/master/tools/fastqc-util/fastqc-util-tsv.cwl
    in:
      fastqcResults: fastqc/fastqc_result
    out:
      [fastqc_summary]
  fastqc-util-ttl:
    run: https://github.com/pitagora-network/pitagora-cwl/raw/master/tools/fastqc-util/fastqc-util-ttl.cwl
    in:
      fastqcResults: fastqc/fastqc_result
    out:
      [fastqc_summary]

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
