cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/annovar
baseCommand: ["table_annovar.pl"]
stdout: annovar_stdout
successCodes: [0, 1]

inputs: []
outputs:
  annovar_version_stdout:
    type: stdout
