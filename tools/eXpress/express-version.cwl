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

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
