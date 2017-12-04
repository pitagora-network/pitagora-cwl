cwlVersion: v1.0
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/rsem

baseCommand: rsem-prepare-reference

arguments: ["--star", "--star-path", "/usr/local/STAR/bin/Linux_x86_64_static"]

inputs:
  threads:
    type: string
    inputBinding:
      prefix: --num-threads
  gtf:
    type: File
    inputBinding:
      prefix: --gtf
      position: 1
  genome:
    type: File
    inputBinding:
      position: 2
  rsem_index_prefix:
    type: string
    inputBinding:
      position: 3

outputs:
  rsem_index:
    type: File[]
    outputBinding:
      glob: "*"
