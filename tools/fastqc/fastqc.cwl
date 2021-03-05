cwlVersion: v1.0
class: CommandLineTool
label: "FastQC: A quality control tool for high throughput sequence data"
doc: "FastQC aims to provide a simple way to do some quality control checks on raw sequence data coming from high throughput sequencing pipelines. It provides a modular set of analyses which you can use to give a quick impression of whether your data has any problems of which you should be aware before doing any further analysis. http://www.bioinformatics.babraham.ac.uk/projects/fastqc/"

hints:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/fastqc:0.11.7--pl5.22.0_2

baseCommand: [fastqc]

arguments:
  - prefix: --outdir
    valueFrom: $(runtime.outdir)

inputs:
  seqfile:
    label: "a set of sequence files"
    doc: "a set of sequence files"
    type: File[]
    inputBinding:
      position: 100
  casava:
    label: "Files come from raw casava output"
    doc: "Files come from raw casava output. Files in the same sample group (differing only by the group number) will be analysed as a set rather than individually. Sequences with the filter flag set in the header will be excluded from the analysis. Files must have the same names given to them by casava (including being gzipped and ending with .gz) otherwise they won't be grouped together correctly."
    type: boolean?
    default: false
    inputBinding:
      prefix: --casava
  nano:
    label: "Files come from naopore sequences and are in fast5 format"
    doc: "Files come from naopore sequences and are in fast5 format. In this mode you can pass in directories to process and the program will take in all fast5 files within those directories and produce a single output file from the sequences found in all files."
    type: boolean?
    default: false
    inputBinding:
      prefix: --nano
  nofilter:
    label: "If running with --casava then don't remove read flagged by casava as poor quality when performing the QC analysis."
    doc: "If running with --casava then don't remove read flagged by casava as poor quality when performing the QC analysis."
    type: boolean?
    default: false
    inputBinding:
      prefix: --nofilter
  extract:
    label: "the zipped output file will be uncompressed"
    doc: "If set then the zipped output file will be uncompressed in the same directory after it has been created. By default this option will be set if fastqc is run in non-interactive mode."
    type: boolean?
    default: false
    inputBinding:
      prefix: --extract
  java:
    label: "the full path to the java binary you want to use to launch fastqc"
    doc: "Provides the full path to the java binary you want to use to launch fastqc. If not supplied then java is assumed to be in your path."
    type: File?
    inputBinding:
      prefix: --java
  noextract:
    label: "Do not uncompress the output file"
    doc: "Do not uncompress the output file after creating it. You should set this option if you do not wish to uncompress the output when running in non-interactive mode."
    type: boolean?
    default: true
    inputBinding:
      prefix: --noextract
  nogroup:
    label: "Disable grouping of bases for reads >50bp"
    doc: "Disable grouping of bases for reads >50bp. All reports will show data for every base in the read. WARNING: Using this option will cause fastqc to crash and burn if you use it on really long reads, and your plots may end up a ridiculous size. You have been warned!"
    type: boolean?
    default: true
    inputBinding:
      prefix: --nogroup
  min_length:
    label: "Sets an artificial lower limit on the length of the sequence to be shown in the report"
    doc: "Sets an artificial lower limit on the length of the sequence to be shown in the report. As long as you set this to a value greater or equal to your longest read length then this will be the sequence length used to create your read groups. This can be useful for making directly comaparable statistics from datasets with somewhat variable read lengths."
    type: int?
    inputBinding:
      prefix: --min_length
  input_format:
    label: "Bypasses the normal sequence file format detection and forces the program to use the specified format"
    doc: "Bypasses the normal sequence file format detection and forces the program to use the specified format. Valid formats are bam,sam,bam_mapped,sam_mapped and fastq"
    type: string?
    inputBinding:
      prefix: --format
  nthreads:
    label: "the number of files which can be processed simultaneously"
    doc: "Specifies the number of files which can be processed simultaneously. Each thread will be allocated 250MB of memory so you shouldn't run more threads than your available memory will cope with, and not more than 6 threads on a 32 bit machine"
    type: int
    inputBinding:
      prefix: --threads
  contaminants:
    label: "a non-default file which contains the list of contaminants to screen overrepresented sequences against"
    doc: "Specifies a non-default file which contains the list of contaminants to screen overrepresented sequences against. The file must contain sets of named contaminants in the form name[tab]sequence. Lines prefixed with a hash will be ignored."
    type: File?
    inputBinding:
      prefix: --contaminants
  adapters:
    label: "a non-default file which contains the list of adapter sequences which will be explicity searched against the library"
    doc: "Specifies a non-default file which contains the list of adapter sequences which will be explicity searched against the library. The file must contain sets of named adapters in the form name[tab]sequence. Lines prefixed with a hash will be ignored."
    type: File?
    inputBinding:
      prefix: --adapters
  limits:
    label: "a non-default file which contains a set of criteria which will be used to determine the warn/error limits for the various modules"
    doc: "Specifies a non-default file which contains a set of criteria which will be used to determine the warn/error limits for the various modules. This file can also be used to selectively remove some modules from the output all together. The format needs to mirror the default limits.txt file found in the Configuration folder."
    type: File?
    inputBinding:
      prefix: --limits
  kmers:
    label: "the length of Kmer to look for in the Kmer content module"
    doc: "Specifies the length of Kmer to look for in the Kmer content module. Specified Kmer length must be between 2 and 10. Default length is 7 if not specified."
    type: int?
    inputBinding:
      prefix: --kmers
  quiet:
    label: "Supress all progress messages on stdout and only report errors"
    doc: "Supress all progress messages on stdout and only report errors."
    type: boolean?
    default: false
    inputBinding:
      prefix: --quiet
  dir:
    label: "a directory to be used for temporary files written when generating report images"
    doc: "Selects a directory to be used for temporary files written when generating report images. Defaults to system temp directory if not specified."
    type: Directory?
    inputBinding:
      prefix: --dir

outputs:
  fastqc_result:
    type: File[]
    outputBinding:
      glob: "*_fastqc.zip"

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
