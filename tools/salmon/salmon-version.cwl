cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: combinelab/salmon
baseCommand: ["salmon", "--version"]
stderr: salmon_stderr

inputs: []
outputs:
  salmon_version_stderr:
    type: stderr
