cwlVersion: v1.0
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: quay.io/inutano/sra-toolkit:v2.9.0

baseCommand: [pfastq-dump, --split-spot, --stdout, --readids]

inputs:
  sraFiles:
    type: File[]
    inputBinding:
      position: 1
  nthreads:
    type: int
    inputBinding:
      prefix: -t
  out_fastq_prefix:
    type: string

outputs:
  fastq:
    type: stdout

stdout: $(inputs.out_fastq_prefix).fastq
