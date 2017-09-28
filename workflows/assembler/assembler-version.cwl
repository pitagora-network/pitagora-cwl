### Please executes this program with "--outdir" option.
cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
#    dockerPull: DOCKER_NAME # specify docker
#    dockerPull: yyabuki/docker-megahit
    dockerPull: yyabuki/docker-a5-miseq
#    dockerPull: yyabuki/docker-sga

inputs: []
arguments: ["version", "/var/spool/cwl"]
outputs:
  version_file:
    type: File
    outputBinding:
      glob: "version"
