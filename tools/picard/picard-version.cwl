cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: broadinstitute/picard:latest
baseCommand: ["AddOrReplaceReadGroups", "--version"]
stderr: picard_stderr
successCodes: [0, 1]

inputs: []
outputs:
  picard_version_stderr:
    type: stderr
