cwlVersion: v1.0
class: CommandLineTool
baseCommand: [grep, -v, '^\[']
stdout: adrenal.sam
inputs:
  tmpoutput:
    type: File
    inputBinding:
      position: 1
outputs:
  sam:
    type: stdout
