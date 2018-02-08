cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/samtools:1.4.1
baseCommand: samtools
stderr: samtools_stderr
successCodes: [0, 1]

inputs: []
outputs:
  samtools_version_stderr:
    type: stderr
