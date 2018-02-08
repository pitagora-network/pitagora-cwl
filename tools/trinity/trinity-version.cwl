cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: comics/trinityrnaseq:2.2.0
baseCommand: ["Trinity", "--version"]
stdout: trinity_stdout
successCodes: [0, 1]

inputs: []
outputs:
  trinity_version_stdout:
    type: stdout
