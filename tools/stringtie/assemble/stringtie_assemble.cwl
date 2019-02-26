cwlVersion: v1.0
class: CommandLineTool
label: "StringTie: Transcript assembly and quantification for RNA-Seq"
doc: "StringTie is a fast and highly efficient assembler of RNA-Seq alignments into potential transcripts. It uses a novel network flow algorithm as well as an optional de novo assembly step to assemble and quantitate full-length transcripts representing multiple splice variants for each gene locus. Its input can include not only the alignments of raw reads used by other transcript assemblers, but also alignments longer sequences that have been assembled from those reads. https://ccb.jhu.edu/software/stringtie/index.shtml?t=manual"

hints:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/stringtie:1.3.0--hd28b015_2

baseCommand: [stringtie]

arguments:
  - prefix: -o
    valueFrom: $(runtime.outdir)/$(inputs.output_filename)

inputs:
  input_bam:
    label: "Sorted BAM file"
    doc: "a BAM file with RNA-Seq read mappings which must be sorted by their genomic location"
    type: File
    inputBinding:
      position: 0
  output_filename:
    label: "The name of the output GTF file"
    doc: "Sets the name of the output GTF file where StringTie will write the assembled transcripts."
    type: string
    default: "stringtie_out.gtf"
  nthreads:
    label: "The number of processing threads"
    doc: "Specify the number of processing threads (CPUs) to use for transcript assembly. The default is 1."
    type: int
    default: 1
    inputBinding:
      prefix: -p
  annotation:
    label: "The reference annotation file"
    doc: "Use the reference annotation file (in GTF or GFF3 format) to guide the assembly process. The output will include expressed reference transcripts as well as any novel transcripts that are assembled."
    type: File
    inputBinding:
      prefix: -G
outputs:
  assemble_output:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)

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
