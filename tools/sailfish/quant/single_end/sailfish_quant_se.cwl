cwlVersion: v1.0
class: CommandLineTool
label: "Sailfish quant: quantifying the samples (For single end reads)"
doc: "Sailfish: Rapid Alignment-free Quantification of Isoform Abundance http://www.cs.cmu.edu/~ckingsf/software/sailfish/ (no documentation for command line options, see sailfish quant --help. sailfish quant has many advanced options, here are only basic options defined.)"

hints:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/sailfish:0.10.1--h6516f61_3

baseCommand: [sailfish, quant]

arguments:
  - prefix: --output
    valueFrom: $(runtime.outdir)/$(inputs.quant_out_dirname)

inputs:
  lib_type:
    label: "Format string describing the library type"
    doc: "Format string describing the library type"
    type: string
    default: IU
    inputBinding:
      prefix: --libType
  index_dir:
    label: "sailfish index"
    doc: "sailfish index"
    type: Directory
    inputBinding:
      prefix: --index
  quant_out_dirname:
    label: "Output quantification directory"
    doc: "Output quantification directory."
    type: string
    default: sailfish_quant
  fq:
    label: "List of files containing unmated reads of"
    doc: "List of files containing unmated reads of (e.g. single-end reads)"
    type: File[]
    inputBinding:
      prefix: --unmatedReads
  nthreads:
    label: "The number of threads to use concurrently."
    doc: "The number of threads to use concurrently."
    type: int
    default: 2
    inputBinding:
      prefix: --threads
  bias_correct:
    label: "Perform sequence-specific bias correction."
    doc: "Perform sequence-specific bias correction."
    type: boolean?
    inputBinding:
      prefix: --biasCorrect
  gc_bias_correct:
    label: "[experimental] Perform fragment GC bias correction"
    doc: "[experimental] Perform fragment GC bias correction"
    type: boolean?
    inputBinding:
        prefix: --gcBiasCorrect
  gibbs_samples:
    label: "Number of Gibbs sampling rounds"
    doc: "*super*-experimental]: Number of Gibbs sampling rounds to perform."
    type: int
    default: 0
    inputBinding:
      prefix: --numGibbsSamples
  num_bootstraps:
    label: "Number of bootstrap samples to generate"
    doc: "[*super*-experimental]: Number of bootstrap samples to generate. Note: This is mutually exclusive with Gibbs sampling."
    type: int
    default: 0
    inputBinding:
      prefix: --numBootstraps

outputs:
  quant_results:
    type: Directory
    outputBinding:
      glob: $(inputs.quant_out_dirname)

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
  - https://schema.org/version/latest/schemaorg-current-http.rdf
  - http://edamontology.org/EDAM_1.18.owl
