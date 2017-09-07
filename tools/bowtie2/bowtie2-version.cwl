cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/bowtie2
baseCommand: ["bowtie2", "--version"]
stdout: bowtie2_stdout

inputs: []
outputs:
  bowtie2_version_stdout:
    type: stdout
