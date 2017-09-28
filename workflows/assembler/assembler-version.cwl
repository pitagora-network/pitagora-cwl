### Please executes this program with "--outdir" option.
cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: DOCKER_NAME # (e.g. yyabuki/docker-idba)

inputs: []
arguments: ["version", "/var/spool/cwl"]
outputs:
  version_file:
    type: File
    outputBinding:
      glob: "version"
