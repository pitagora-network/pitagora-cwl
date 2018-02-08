cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/kallisto:0.43.1
baseCommand: ["kallisto", "quant"]
stdout: kallisto_stdout

inputs: []
outputs:
  kallisto_version_stdout:
    type: stdout
