cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/star
baseCommand: ["STAR", "--version"]
stdout: star_stdout

inputs: []
outputs:
  star_version_stdout:
    type: stdout
