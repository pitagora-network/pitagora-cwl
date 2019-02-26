cwlVersion: v1.0
class: CommandLineTool
label: "rsem-calculate-expression: calculate expression values (BAM input version CWL)"
doc: "RSEM is a software package for estimating gene and isoform expression levels from RNA-Seq data. The RSEM package provides an user-friendly interface, supports threads for parallel computation of the EM algorithm, single-end and paired-end read data, quality scores, variable-length reads and RSPD estimation. In addition, it provides posterior mean and 95% credibility interval estimates for expression levels.  http://deweylab.biostat.wisc.edu/rsem/rsem-calculate-expression.html"

hints:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/rsem:1.3.0--boost1.64_3

baseCommand: [rsem-calculate-expression, --star, --keep-intermediate-files, --no-bam-output]

arguments:
  - valueFrom: $(inputs.rsem_index_dir.path)/$(inputs.rsem_index_prefix)
    position: 2

inputs:
  nthreads:
    label: "Number of threads to use"
    doc: "Number of threads to use. Both Bowtie/Bowtie2, expression estimation and 'samtools sort' will use this many threads. (Default: 1)"
    type: int
    inputBinding:
      prefix: --num-threads
      position: 0
  input_fastq:
    label: "Comma-separated list of files containing single-end reads"
    doc: "Comma-separated list of files containing single-end reads. By default, these files are assumed to be in FASTQ format."
    type: File[]
    inputBinding:
      position: 1
      itemSeparator: ","
  rsem_index_dir:
    label: "A path to the directory contains RSEM index files"
    doc: "A path to the directory contains RSEM index files"
    type: Directory
  rsem_index_prefix:
    label: "The name of RSEM index files"
    doc: "The name of RSEM index files"
    type: string
  rsem_output_prefix:
    label: "The name of the sample analyzed"
    doc: "The name of the sample analyzed. All output files are prefixed by this name (e.g., sample_name.genes.results)"
    type: string
    inputBinding:
      position: 3

outputs:
  genes_result:
    type: File
    outputBinding:
      glob: "*.genes.results"
  isoforms_result:
    type: File
    outputBinding:
      glob: "*.isoforms.results"
  stat:
    type: Directory
    outputBinding:
      glob: "*.stat"
  star_output:
    type: Directory
    outputBinding:
      glob: "*.temp"

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
