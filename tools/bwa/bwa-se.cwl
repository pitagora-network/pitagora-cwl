cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/bwa
baseCommand: bwa
requirements:
  - class: InlineJavascriptRequirement
inputs:
  mem:
    type: boolean
    inputBinding:
      position: 1
      prefix: mem
  mark_shorter_split_hits:
    type: boolean
    inputBinding:
      position: 2
      prefix: -M
  read_group_header_line:
    type: string
    inputBinding:
      position: 3
      prefix: -R
  genome_index:
    type: File 
    inputBinding:
      position: 4
  fq:
    type: File
    inputBinding:
      position: 5
  process:
    type: int?
    inputBinding:
      prefix: -t
      position: 7
outputs:
  tmpsam:
    type: File
    outputBinding:
      glob: "*"
stdout:
  ${
    var outfile = inputs.fq.basename.replace('.sam', '') + '.tmp.sam';
    return outfile;
  }
