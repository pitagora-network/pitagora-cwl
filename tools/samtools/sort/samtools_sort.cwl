cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/samtools:1.4.1

baseCommand: ["samtools", "sort"]

arguments:
  - prefix: -o
    valueFrom: $(runtime.outdir)/$(inputs.output_filename)

inputs:
  output_filename:
    type: string
    default: sorted.bam
  input_bam:
    type: File
    inputBinding:
      position: 50

outputs:
  sorted_bamfile:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)
