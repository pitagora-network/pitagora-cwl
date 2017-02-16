cwlVersion: v1.0
class: Workflow

inputs:
  fastq1: File
  fastq2: File
  gi: File
  d: boolean
  dc: boolean
  p: int?
  o: string

outputs:
  sam:
    type: File
    outputSource: hisat2/output

steps:
  hisat2:
    run: hisat2.cwl
    in:
      exclusive_parameters:
        - id: pairend
          fq1:
            source: fastq1
        - id: pairend
          fq2:
            source: fastq2
      genome_index:
        source: gi
      dta:
        source: d
      dta_cufflinks:
        source: dc
      output:
        source: o
    out: [sam]
