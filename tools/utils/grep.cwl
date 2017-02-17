cwlVersion: v1.0
class: CommandLineTool
baseCommand: [grep, -v, '^\[']
requirements:
  - class: InlineJavascriptRequirement
inputs:
  tmpoutput:
    type: File
    inputBinding:
      position: 1
outputs:
  sam:
    type: File
    outputBinding:
      glob: "*"
stdout: $(inputs.tmpoutput.basename.replace('.tmp.sam', '.trim.sam'))
