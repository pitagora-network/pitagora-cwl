cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/star:2.5.2b
baseCommand: ["STAR", "--version"]
stdout: star_stdout

inputs: []
outputs:
  star_version_stdout:
    type: stdout
