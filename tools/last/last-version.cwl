cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/last:894
baseCommand: ["lastal", "--version"]
stdout: last_stdout

inputs: []
outputs:
  last_version_stdout:
    type: stdout
