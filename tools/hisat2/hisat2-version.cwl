cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: limesbonn/hisat2
baseCommand: ["hisat2", "--version"]
stdout: hisat2_stdout

inputs: []
outputs:
  hisat2_version_stdout:
    type: stdout
