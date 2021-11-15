cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: nasuno/cufflinks:2.2.1
baseCommand: cufflinks
stderr: cufflinks_stderr
successCodes: [0, 1]

inputs: []
outputs:
  cufflinks_version_stderr:
    type: stderr

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl

$schemas:
  - https://schema.org/version/latest/schemaorg-current-http.rdf
  - http://edamontology.org/EDAM_1.18.owl
