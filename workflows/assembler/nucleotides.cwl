#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/path/to/nucleotids.sh]
requirements:
  - class: InlineJavascriptRequirement
inputs:
  docker_name:
    type: string
    inputBinding:
      position: 1
  process_tag:
    type: string
    inputBinding:
      position: 2
  fq:
    type: File
    inputBinding:
      position: 3
  result_directory:
    type: string
    inputBinding:
      position: 4
outputs: []

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl

$schemas:
  - https://schema.org/version/latest/schemaorg-current-http.rdf
  - http://edamontology.org/EDAM_1.18.owl
