cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: yyabuki/docker-ngs-version
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
