cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: nasuno/cufflinks:2.2.1
baseCommand: cufflinks
stderr: cufflinks_stderr
successCodes: [0, 1]

inputs: []
outputs:
  cufflinks_version_stderr:
    type: stderr
