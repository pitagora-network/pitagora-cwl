cwlVersion: v1.0
class: CommandLineTool
label: "Cufflinks: Transcriptome assembly and differential expression analysis for RNA-Seq"
doc: "Transcriptome assembly and differential expression analysis for RNA-Seq. http://cole-trapnell-lab.github.io/cufflinks/cufflinks/index.html"

hints:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/cufflinks:2.2.1--py27_2

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
