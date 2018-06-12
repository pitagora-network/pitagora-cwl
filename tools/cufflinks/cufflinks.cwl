cwlVersion: v1.0
class: CommandLineTool
label: "Cufflinks: Transcriptome assembly and differential expression analysis for RNA-Seq"
doc: "Transcriptome assembly and differential expression analysis for RNA-Seq. http://cole-trapnell-lab.github.io/cufflinks/cufflinks/index.html"

hints:
  DockerRequirement:
    dockerPull: nasuno/cufflinks:2.2.1

baseCommand: cufflinks

arguments:
  - prefix: -o
    valueFrom: $(runtime.outdir)

inputs:
  nthreads:
    label: "number of threads used during analysis"
    doc: "number of threads used during analysis"
    type: int?
    inputBinding:
      prefix: -p
  annotation:
    label: "quantitate against reference transcript annotations"
    doc: "quantitate against reference transcript annotations"
    type: File
    inputBinding:
      prefix: --GTF
  input_bam:
    label: "Input bam file for cufflinks"
    doc: "Input bam file for cufflinks"
    type: File
    inputBinding:
      position: 50

outputs:
  cufflinks_result:
    type:
      type: array
      items: File
    outputBinding:
      glob: '*'
