cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/sailfish
baseCommand: ["sailfish", "-h"]
stderr: sailfish_stderr

inputs: []
outputs:
  sailfish_version_stderr:
    type: stderr
