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

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
