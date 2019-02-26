### Please executes this program with "--outdir" option.
cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: DOCKER_NAME # (e.g. yyabuki/docker-idba)

inputs: []
arguments: ["version", $(runtime.outdir)]
outputs:
  version_file:
    type: File
    outputBinding:
      glob: "version"

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
