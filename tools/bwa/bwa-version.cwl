cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/bwa:v0.7.15
baseCommand: ["bwa"]
stderr: bwa_stderr
successCodes: [0, 1]

inputs: []
outputs:
  bwa_version_stderr:
    type: stderr
