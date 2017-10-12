cwlVersion: v1.0
class: CommandLineTool

# hints:                             # UNCOMMENT THIS LINE TO USE DOCKER
#   DockerRequirement:               # UNCOMMENT THIS LINE TO USE DOCKER
#     dockerPull: inutano/lftp:0.1.0 # UNCOMMENT THIS LINE TO USE DOCKER

baseCommand: [lftp]
requirements:
  - class: InlineJavascriptRequirement

arguments:
  - valueFrom: $("set net:max-retries 5; set net:timeout 10; mirror --parallel=4 " + inputs.sraURL)
    prefix: "-c"

inputs:
  sraURL:
    type: string

outputs:
  sraFiles:
    type: File[]
    outputBinding:
      glob: "**"
      outputEval: |
        ${
          var r = [];
          for (var i = 0; i < self.length; i++){
            var run_dirs = self[i].listing;
            for (var j = 0; j < run_dirs.length; j++){
              var run_data = run_dirs[j].listing
              for (var k = 0; k < run_data.length; k++){
                r.push(run_data[k])
              }
            }
          }
          return r;
        }
