cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/sailfish:0.10.0
baseCommand: ["sailfish", "-h"]
stderr: sailfish_stderr

inputs: []
outputs:
  sailfish_version_stderr:
    type: stderr
