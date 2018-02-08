cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: humancellatlas/hisat2:2-2.1.0
baseCommand: ["hisat2", "--version"]
stdout: hisat2_stdout

inputs: []
outputs:
  hisat2_version_stdout:
    type: stdout
