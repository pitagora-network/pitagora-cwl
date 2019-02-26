cwlVersion: v1.0
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: inutano/rsubread:0.1.1

requirements:
  - class: InlineJavascriptRequirement

baseCommand: [Rscript]

arguments: ["--vanilla", $(inputs.readcount_script)]

inputs:
  bam:
    type: File
    inputBinding:
      prefix: --bam

  gtf:
    type: File
    inputBinding:
      prefix: --gtf

  readcount_script:
    type: File

outputs:
  readCount:
    type: File
    outputBinding:
      glob: "*_rc.txt"

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl
s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0003-3777-5945
    s:email: mailto:inutano@gmail.com
    s:name: Tazro Ohta

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
