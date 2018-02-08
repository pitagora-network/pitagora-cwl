cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: biodckrdev/bowtie:1.1.2
baseCommand: ["bowtie", "--version"]
stdout: bowtie_stdout

inputs: []
outputs:
  bowtie_version_stdout:
    type: stdout
