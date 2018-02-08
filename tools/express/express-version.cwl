cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/express:1.5.1
baseCommand: ["express", "--help"]
stderr: express_stderr
successCodes: [0, 1]

inputs: []
outputs:
  express_version_stderr:
    type: stderr
