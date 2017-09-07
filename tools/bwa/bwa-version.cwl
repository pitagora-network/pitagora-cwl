cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/bwa
baseCommand: ["bwa"]
stderr: bwa_stderr
successCodes: [0, 1]

inputs: []
outputs:
  bwa_version_stderr:
    type: stderr
