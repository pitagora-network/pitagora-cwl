cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/docker-ngs-version:0.1.0
baseCommand: ["get_version.py"]
requirements:
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.infile)
  - class: InlineJavascriptRequirement
stdout: $((inputs.infile.basename).split('_')[0] + '_version')

inputs:
  infile:
    type: File
    inputBinding:
      prefix: --infile
      position: 1
      valueFrom: $(self.basename)
outputs:
  version_output:
    type: stdout

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
