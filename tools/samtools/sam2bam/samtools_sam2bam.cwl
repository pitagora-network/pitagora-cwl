cwlVersion: v1.0
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/samtools:1.4.1

baseCommand: ["samtools", "view", "-b"]

arguments:
  - prefix: -o
    valueFrom: $(runtime.outdir)/$(inputs.output_filename)

inputs:
  output_filename:
    label: "Filename to write output to"
    doc: "Filename to write output to"
    type: string
    default: out.bam
  input_sam:
    label: "SAM format input file"
    doc: "SAM format input file"
    type: File
    inputBinding:
      position: 50

outputs:
  bamfile:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)
