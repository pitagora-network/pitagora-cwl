cwlVersion: v1.0
class: CommandLineTool
label: "Sailfish quant: quantifying the samples (For paired end reads)"
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
  fq1:
    label: "File containing the #1 mates"
    doc: "File containing the #1 mates"
    type: File
    inputBinding:
      prefix: --mates1
  fq2:
    label: "File containing the #2 mates"
    doc: "File containing the #2 mates"
    type: File
    inputBinding:
      prefix: --mates2
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
