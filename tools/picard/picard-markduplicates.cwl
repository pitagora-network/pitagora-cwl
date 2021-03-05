cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: broadinstitute/picard:latest
baseCommand: MarkDuplicates
inputs:
  bam:
    type: File 
    inputBinding:
      position: 1
      prefix: INPUT=
      separate: false
  output:
    type: string
    inputBinding:
      position: 2
      prefix: OUTPUT=
      separate: false
  metout: 
    type: string
    inputBinding:
      position: 3
      prefix: METRICS_FILE=
      separate: false
outputs:
  dupread:
    type: File
    outputBinding:
      glob: $(inputs.output)
  metrics:
    type: File
    outputBinding:
      glob: $(inputs.metout)

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
