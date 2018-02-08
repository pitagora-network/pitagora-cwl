cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/stringtie:1.2.3
baseCommand: ["stringtie", "--version"]
stdout: stringtie_stdout

inputs: []
outputs:
  stringtie_version_stdout:
    type: stdout
