cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: combinelab/salmon:0.8.2
baseCommand: ["salmon", "--version"]
stderr: salmon_stderr

inputs: []
outputs:
  salmon_version_stderr:
    type: stderr
