cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: nasuno/tophat2:2.0.9
baseCommand: ["tophat2", "--version"]
stdout: tophat2_stdout

inputs: []
outputs:
  tophat2_version_stdout:
    type: stdout
