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
