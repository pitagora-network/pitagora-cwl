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
