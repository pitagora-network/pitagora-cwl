cwlVersion: v1.0
class: CommandLineTool
label: "TopHat is a fast splice junction mapper for RNA-Seq reads. [cwl for single end]"
doc: "TopHat is a fast splice junction mapper for RNA-Seq reads. It aligns RNA-Seq reads to mammalian-sized genomes using the ultra high-throughput short read aligner Bowtie, and then analyzes the mapping results to identify splice junctions between exons. http://ccb.jhu.edu/software/tophat/index.shtml"

hints:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/tophat:2.1.1--py27_1

baseCommand: [tophat2]

arguments:
  - prefix: --output-dir
    valueFrom: $(runtime.outdir)
  - position: 1
    valueFrom: $(inputs.genome_index_dir.path)/$(inputs.genome_index_base)

inputs:
  read-mismatches:
    label: "Final read alignments having more than these many mismatches are discarded. The default is 2."
    doc: "Final read alignments having more than these many mismatches are discarded. The default is 2."
    type: int?
    inputBinding:
      prefix: --read-mismatches
  read-gap-length:
    label: "Final read alignments having more than these many total length of gaps are discarded. The default is 2."
    doc: "Final read alignments having more than these many total length of gaps are discarded. The default is 2."
    type: int?
    inputBinding:
      prefix: --read-gap-length
  read-edit-dist:
    label: "Final read alignments having more than these many edit distance are discarded. The default is 2."
    doc: "Final read alignments having more than these many edit distance are discarded. The default is 2."
    type: int?
    inputBinding:
      prefix: --read-edit-dist
  read-realign-edit-dist:
    label: "re-align reads for which the edit distance of an alignment obtained in a previous mapping step is above or equal to this option value"
    doc: "This option can direct TopHat to re-align reads for which the edit distance of an alignment obtained in a previous mapping step is above or equal to this option value. If you set this option to 0, TopHat will map every read in all the mapping steps (transcriptome if you provided gene annotations, genome, and finally splice variants detected by TopHat), reporting the best possible alignment found in any of these mapping steps. This may greatly increase the mapping accuracy at the expense of an increase in running time. The default value for this option is set such that TopHat will not try to realign reads already mapped in earlier steps"
    type: int?
    inputBinding:
      prefix: --read-realign-edit-dist
  mate-inner-dist:
    label: "expected (mean) inner distance between mate pairs"
    doc: "This is the expected (mean) inner distance between mate pairs. For, example, for paired end runs with fragments selected at 300bp, where each end is 50bp, you should set -r to be 200. The default is 50bp."
    type: int?
    inputBinding:
      prefix: --mate-inner-dist
  mate-std-dev:
    label: "The standard deviation for the distribution on inner distances between mate pairs. The default is 20bp."
    doc: "The standard deviation for the distribution on inner distances between mate pairs. The default is 20bp."
    type: int?
    inputBinding:
      prefix: --mate-std-dev
  min-anchor-length:
    label: "report junctions spanned by reads with at least this many bases on each side of the junction"
    doc: "The 'anchor length'. TopHat will report junctions spanned by reads with at least this many bases on each side of the junction. Note that individual spliced alignments may span a junction with fewer than this many bases on one side. However, every junction involved in spliced alignments is supported by at least one read with this many bases on each side.	This must be at least 3 and the default is 8."
    type: int?
    inputBinding:
      prefix: --min-anchor-length
  min-intron-length:
    label: "The minimum intron length"
    doc: "The minimum intron length. TopHat will ignore donor/acceptor pairs closer than this many bases apart. The default is 70"
    type: int?
    inputBinding:
      prefix: --min-intron-length
  max-intron-length:
    label: "The maximum intron length"
    doc: "The maximum intron length. When searching for junctions ab initio, TopHat will ignore donor/acceptor pairs farther than this many bases apart, except when such a pair is supported by a split segment alignment of a long read. The default is 500000."
    type: int?
    inputBinding:
      prefix: --max-intron-length
  max-insertion-length:
    label: "The maximum insertion length. The default is 3."
    doc: "The maximum insertion length. The default is 3."
    type: int?
    inputBinding:
      prefix: --max-insertion-length
  max-deletion-length:
    label: "The maximum deletion length. The default is 3."
    doc: "The maximum deletion length. The default is 3."
    type: int?
    inputBinding:
      prefix: --max-deletion-length
  nthreads:
    label: "Use this many threads to align reads. The default is 1."
    doc: "Use this many threads to align reads. The default is 1."
    type: int?
    inputBinding:
      prefix: --num-threads
  gtf:
    label: "a set of gene model annotations and/or known transcripts"
    doc: "Supply TopHat with a set of gene model annotations and/or known transcripts, as a GTF 2.2 or GFF3 formatted file. If this option is provided, TopHat will first extract the transcript sequences and use Bowtie to align reads to this virtual transcriptome first. Only the reads that do not fully map to the transcriptome will then be mapped on the genome. The reads that did map on the transcriptome will be converted to genomic mappings (spliced as needed) and merged with the novel mappings and junctions in the final tophat output."
    type: File?
    inputBinding:
      prefix: --GTF
  genome_index_dir:
    label: "The directory of the genome index to be searched"
    doc: "The directory of the genome index to be searched"
    type: Directory
  genome_index_base:
    label: "The basename of the genome index to be searched"
    doc: "The basename of the genome index to be searched"
    type: string
  fq:
    label: "The read in FASTQ or FASTA format"
    doc: "The read in FASTQ or FASTA format"
    type: File[]
    inputBinding:
      position: 2
      itemSeparator: ","

outputs:
  accepted_hits_bam:
    type: File
    outputBinding:
      glob: accepted_hits.bam
  junctions_bed:
    type: File
    outputBinding:
      glob: junctions.bed
  insertions_bed:
    type: File
    outputBinding:
      glob: insertions.bed
  deletions_bed:
    type: File
    outputBinding:
      glob: deletions.bed

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
