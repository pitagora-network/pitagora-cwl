cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/kallisto
baseCommand: ["kallisto", "quant"]
stdout: kallisto_stdout

inputs: []
outputs:
  kallisto_version_stdout:
    type: stdout
