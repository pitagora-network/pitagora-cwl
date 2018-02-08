cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: biodckrdev/gatk:3.4
baseCommand: ["java", "-jar", "/home/biodocker/bin/gatk/target/GenomeAnalysisTK.jar", "--version"]
stdout: gatk_stdout

inputs: []
outputs:
  gatk_version_stdout:
    type: stdout
