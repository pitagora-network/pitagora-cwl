cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: comics/trinityrnaseq
baseCommand: ["Trinity", "--version"]
stdout: trinity_stdout
successCodes: [0, 1]

inputs: []
outputs:
  trinity_version_stdout:
    type: stdout
