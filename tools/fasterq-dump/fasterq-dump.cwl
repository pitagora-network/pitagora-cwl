cwlVersion: v1.0
class: CommandLineTool
label: "fasterq-dump: dump .sra format file to generate fastq file, way more faster"
doc: "sra-toolkit: https://github.com/ncbi/sra-tools/wiki/Download-On-Demand"

hints:
  DockerRequirement:
    dockerPull: quay.io/inutano/sra-toolkit:v2.9.2

baseCommand: [fasterq-dump]

inputs:
  srafile:
    type: File
    inputBinding:
      position: -1
    label: "SRA format file to dump to fastq"

  outfile:
    type: string?
    inputBinding:
      prefix: --outfile
    label: "output-file"

  bufsize:
    type: string?
    inputBinding:
      prefix: --bufsize
    label: "size of file-buffer dflt=1MB"

  curcache:
    type: string?
    inputBinding:
      prefix: --curcache
    label: "size of cursor-cache dflt=10MB"

  mem:
    type: string?
    inputBinding:
      prefix: --mem
    label: "memory limit for sorting dflt=100MB"

  temp:
    type: Directory?
    inputBinding:
      prefix: --temp
    label: "where to put temp. files dflt=curr dir"

  nthreads:
    type: int?
    inputBinding:
      prefix: --threads
    label: "how many thread dflt=6"

  progress:
    type: boolean?
    inputBinding:
      prefix: --progress
    label: "show progress"

  details:
    type: boolean?
    inputBinding:
      prefix: --details
    label: "print details"

  split_spot:
    type: boolean?
    default: true
    inputBinding:
      prefix: --split-spot
    label: "split spots into reads"

  split_files:
    type: boolean?
    default: true
    inputBinding:
      prefix: --split-files
    label: "write reads into different files"

  split_3:
    type: boolean?
    inputBinding:
      prefix: --split-3
    label: "writes single reads in special file"

  concatenate_reads:
    type: boolean?
    inputBinding:
      prefix: --concatenate-reads
    label: "writes whole spots into one file"

  print_stdout:
    type: boolean?
    inputBinding:
      prefix: --stdout
    label: "print output to stdout"

  force_overwrite:
    type: boolean?
    inputBinding:
      prefix: --force
    label: "force to overwrite existing file(s)"

  rowid_as_name:
    type: boolean?
    inputBinding:
      prefix: --rowid-as-name
    label: "use row-id as name"

  skip_technical:
    type: boolean?
    default: true
    inputBinding:
      prefix: --skip-technical
    label: "skip technical reads"

  include_technical:
    type: boolean?
    inputBinding:
      prefix: --include-technical
    label: "include technical reads"

  print_read_nr:
    type: boolean?
    inputBinding:
      prefix: --print-read-nr
    label: "print read-numbers"

  min_read_len:
    type: boolean?
    inputBinding:
      prefix: --min-read-len
    label: "filter by sequence-len"

  table:
    type: string?
    inputBinding:
      prefix: --table
    label: "which seq-table to use in case of pacbio"

  strict:
    type: boolean?
    inputBinding:
      prefix: --strict
    label: "terminate on invalid read"

  bases:
    type: int?
    inputBinding:
      prefix: --bases
    label: "filter by bases"

  print_help:
    type: boolean?
    inputBinding:
      prefix: --help
    label: "Output brief explanation for the program."

  print_version:
    type: boolean?
    inputBinding:
      prefix: --version
    label: "Display the version of the program then quit."

  log_level:
    type: int?
    inputBinding:
      prefix: --log-level <level>
    label: "Logging level as number or enum string. One of (fatal|sys|int|err|warn|info|debug) or (0-6) Current/default is warn"

  verbose:
    type: boolean?
    inputBinding:
      prefix: --verbose
    label: "Increase the verbosity of the program status messages. Use multiple times for more verbosity. Negates quiet."

  quiet:
    type: boolean?
    inputBinding:
      prefix: --quiet
    label: "Turn off all status messages for the program. Negated by verbose."

  option_file:
    type: File?
    inputBinding:
      prefix: --option-file <file>
    label: "Read more options and parameters from the file."

outputs:
  fastqFiles:
    type: File[]
    outputBinding:
      glob: "*fastq*"
  forward:
    type: File?
    outputBinding:
      glob: "*_1.fastq*"
  reverse:
    type: File?
    outputBinding:
      glob: "*_2.fastq*"

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
