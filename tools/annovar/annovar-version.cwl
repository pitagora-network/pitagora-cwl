cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/annovar:20160201
baseCommand: ["table_annovar.pl"]
stdout: annovar_stdout
successCodes: [0, 1]

inputs: []
outputs:
  annovar_version_stdout:
    type: stdout

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
