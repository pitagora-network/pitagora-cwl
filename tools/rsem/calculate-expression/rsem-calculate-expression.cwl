cwlVersion: v1.0
class: CommandLineTool
label: "rsem-calculate-expression: calculate expression values (BAM input version CWL)"
doc: "RSEM is a software package for estimating gene and isoform expression levels from RNA-Seq data. The RSEM package provides an user-friendly interface, supports threads for parallel computation of the EM algorithm, single-end and paired-end read data, quality scores, variable-length reads and RSPD estimation. In addition, it provides posterior mean and 95% credibility interval estimates for expression levels.  http://deweylab.biostat.wisc.edu/rsem/rsem-calculate-expression.html"

hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/rsem:1.2.28

baseCommand: [rsem-calculate-expression, --alignments, --no-bam-output]

arguments:
  - valueFrom: $(inputs.rsem_index_dir.path)/$(inputs.rsem_index_prefix)
    position: 2

inputs:
  input_bam:
    label: "BAM formatted input file"
    doc: "BAM formatted input file. If '-' is specified for the filename, the input is instead assumed to come from standard input. RSEM requires all alignments of the same read group together. For paired-end reads, RSEM also requires the two mates of any alignment be adjacent. In addition, RSEM does not allow the SEQ and QUAL fields to be empty. See Description section for how to make input file obey RSEM's requirements."
    type: File
    inputBinding:
      position: 1
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
