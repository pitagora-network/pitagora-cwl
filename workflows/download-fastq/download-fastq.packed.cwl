{
    "$graph": [
        {
            "class": "CommandLineTool",
            "label": "download-sra: A simple download tool to get .sra file",
            "doc": "A simple download tool to get .sra file from a repository of INSDC members. https://github.com/inutano/download-sra",
            "hints": [
                {
                    "dockerPull": "ghcr.io/inutano/download-sra:cb2bba4",
                    "class": "DockerRequirement"
                }
            ],
            "baseCommand": [
                "download-sra"
            ],
            "inputs": [
                {
                    "type": "string",
                    "default": "ncbi",
                    "inputBinding": {
                        "position": 1,
                        "prefix": "-r"
                    },
                    "id": "#download-sra.cwl/repo"
                },
                {
                    "type": [
                        "string",
                        {
                            "type": "array",
                            "items": "string"
                        }
                    ],
                    "inputBinding": {
                        "position": 2
                    },
                    "id": "#download-sra.cwl/run_ids"
                }
            ],
            "outputs": [
                {
                    "type": {
                        "type": "array",
                        "items": "File"
                    },
                    "outputBinding": {
                        "glob": "*sra"
                    },
                    "id": "#download-sra.cwl/sraFiles"
                }
            ],
            "id": "#download-sra.cwl",
            "https://schema.org/license": "https://spdx.org/licenses/Apache-2.0",
            "https://schema.org/codeRepository": "https://github.com/pitagora-network/pitagora-cwl",
            "https://schema.org/author": [
                {
                    "class": "https://schema.org/Person",
                    "https://schema.org/identifier": "https://orcid.org/0000-0003-3777-5945",
                    "https://schema.org/email": "mailto:inutano@gmail.com",
                    "https://schema.org/name": "Tazro Ohta"
                }
            ],
            "$namespaces": {
                "s": "https://schema.org/",
                "edam": "http://edamontology.org/"
            }
        },
        {
            "class": "CommandLineTool",
            "label": "fasterq-dump: dump .sra format file to generate fastq file, way more faster",
            "doc": "sra-toolkit: https://github.com/ncbi/sra-tools/wiki/Download-On-Demand",
            "hints": [
                {
                    "dockerPull": "ncbi/sra-tools:2.11.0",
                    "class": "DockerRequirement"
                },
                {
                    "envDef": [
                        {
                            "envValue": "/root",
                            "envName": "HOME"
                        }
                    ],
                    "class": "EnvVarRequirement"
                }
            ],
            "baseCommand": [
                "fasterq-dump"
            ],
            "inputs": [
                {
                    "type": [
                        "null",
                        "int"
                    ],
                    "inputBinding": {
                        "prefix": "--bases"
                    },
                    "label": "filter by bases",
                    "id": "#fasterq-dump.cwl/bases"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "inputBinding": {
                        "prefix": "--bufsize"
                    },
                    "label": "size of file-buffer dflt=1MB",
                    "id": "#fasterq-dump.cwl/bufsize"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--concatenate-reads"
                    },
                    "label": "writes whole spots into one file",
                    "id": "#fasterq-dump.cwl/concatenate_reads"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "inputBinding": {
                        "prefix": "--curcache"
                    },
                    "label": "size of cursor-cache dflt=10MB",
                    "id": "#fasterq-dump.cwl/curcache"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--details"
                    },
                    "label": "print details",
                    "id": "#fasterq-dump.cwl/details"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--force"
                    },
                    "label": "force to overwrite existing file(s)",
                    "id": "#fasterq-dump.cwl/force_overwrite"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--include-technical"
                    },
                    "label": "include technical reads",
                    "id": "#fasterq-dump.cwl/include_technical"
                },
                {
                    "type": [
                        "null",
                        "int"
                    ],
                    "inputBinding": {
                        "prefix": "--log-level <level>"
                    },
                    "label": "Logging level as number or enum string. One of (fatal|sys|int|err|warn|info|debug) or (0-6) Current/default is warn",
                    "id": "#fasterq-dump.cwl/log_level"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "inputBinding": {
                        "prefix": "--mem"
                    },
                    "label": "memory limit for sorting dflt=100MB",
                    "id": "#fasterq-dump.cwl/mem"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--min-read-len"
                    },
                    "label": "filter by sequence-len",
                    "id": "#fasterq-dump.cwl/min_read_len"
                },
                {
                    "type": [
                        "null",
                        "int"
                    ],
                    "inputBinding": {
                        "prefix": "--threads"
                    },
                    "label": "how many thread dflt=6",
                    "id": "#fasterq-dump.cwl/nthreads"
                },
                {
                    "type": [
                        "null",
                        "File"
                    ],
                    "inputBinding": {
                        "prefix": "--option-file <file>"
                    },
                    "label": "Read more options and parameters from the file.",
                    "id": "#fasterq-dump.cwl/option_file"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "inputBinding": {
                        "prefix": "--outfile"
                    },
                    "label": "output-file",
                    "id": "#fasterq-dump.cwl/outfile"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--help"
                    },
                    "label": "Output brief explanation for the program.",
                    "id": "#fasterq-dump.cwl/print_help"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--print-read-nr"
                    },
                    "label": "print read-numbers",
                    "id": "#fasterq-dump.cwl/print_read_nr"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--stdout"
                    },
                    "label": "print output to stdout",
                    "id": "#fasterq-dump.cwl/print_stdout"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--version"
                    },
                    "label": "Display the version of the program then quit.",
                    "id": "#fasterq-dump.cwl/print_version"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--progress"
                    },
                    "label": "show progress",
                    "id": "#fasterq-dump.cwl/progress"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--quiet"
                    },
                    "label": "Turn off all status messages for the program. Negated by verbose.",
                    "id": "#fasterq-dump.cwl/quiet"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--rowid-as-name"
                    },
                    "label": "use row-id as name",
                    "id": "#fasterq-dump.cwl/rowid_as_name"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "default": true,
                    "inputBinding": {
                        "prefix": "--skip-technical"
                    },
                    "label": "skip technical reads",
                    "id": "#fasterq-dump.cwl/skip_technical"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--split-3"
                    },
                    "label": "writes single reads in special file",
                    "id": "#fasterq-dump.cwl/split_3"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "default": true,
                    "inputBinding": {
                        "prefix": "--split-files"
                    },
                    "label": "write reads into different files",
                    "id": "#fasterq-dump.cwl/split_files"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "default": true,
                    "inputBinding": {
                        "prefix": "--split-spot"
                    },
                    "label": "split spots into reads",
                    "id": "#fasterq-dump.cwl/split_spot"
                },
                {
                    "type": [
                        "File",
                        {
                            "type": "array",
                            "items": "File"
                        }
                    ],
                    "inputBinding": {
                        "position": -1
                    },
                    "label": "SRA format file to dump to fastq",
                    "id": "#fasterq-dump.cwl/sraFiles"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--strict"
                    },
                    "label": "terminate on invalid read",
                    "id": "#fasterq-dump.cwl/strict"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "inputBinding": {
                        "prefix": "--table"
                    },
                    "label": "which seq-table to use in case of pacbio",
                    "id": "#fasterq-dump.cwl/table"
                },
                {
                    "type": [
                        "null",
                        "Directory"
                    ],
                    "inputBinding": {
                        "prefix": "--temp"
                    },
                    "label": "where to put temp. files dflt=curr dir",
                    "id": "#fasterq-dump.cwl/temp"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--verbose"
                    },
                    "label": "Increase the verbosity of the program status messages. Use multiple times for more verbosity. Negates quiet.",
                    "id": "#fasterq-dump.cwl/verbose"
                }
            ],
            "outputs": [
                {
                    "type": {
                        "type": "array",
                        "items": "File"
                    },
                    "format": "http://edamontology.org/format_1930",
                    "outputBinding": {
                        "glob": "*fastq*"
                    },
                    "id": "#fasterq-dump.cwl/fastqFiles"
                },
                {
                    "type": [
                        "null",
                        {
                            "type": "array",
                            "items": "File"
                        }
                    ],
                    "format": "http://edamontology.org/format_1930",
                    "outputBinding": {
                        "glob": "*_1.fastq*"
                    },
                    "id": "#fasterq-dump.cwl/forward"
                },
                {
                    "type": [
                        "null",
                        {
                            "type": "array",
                            "items": "File"
                        }
                    ],
                    "format": "http://edamontology.org/format_1930",
                    "outputBinding": {
                        "glob": "*_2.fastq*"
                    },
                    "id": "#fasterq-dump.cwl/reverse"
                }
            ],
            "id": "#fasterq-dump.cwl",
            "https://schema.org/license": "https://spdx.org/licenses/Apache-2.0",
            "https://schema.org/codeRepository": "https://github.com/pitagora-network/pitagora-cwl",
            "https://schema.org/author": [
                {
                    "class": "https://schema.org/Person",
                    "https://schema.org/identifier": "https://orcid.org/0000-0003-3777-5945",
                    "https://schema.org/email": "mailto:inutano@gmail.com",
                    "https://schema.org/name": "Tazro Ohta"
                }
            ]
        },
        {
            "class": "Workflow",
            "label": "Download sequence data from Sequence Read Archive and dump to FASTQ file",
            "doc": "input variable repo should be one of ncbi or ebi",
            "inputs": [
                {
                    "type": [
                        "null",
                        "int"
                    ],
                    "default": 4,
                    "label": "Optional: number of threads to be used by fasterq-dump (default: 4)",
                    "doc": "Optional: number of threads to be used by fasterq-dump (default: 4)",
                    "id": "#main/nthreads"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "default": "ebi",
                    "label": "Optional: repository to be used. ncbi or ebi",
                    "doc": "Optional: repository to be used. ncbi or ebi",
                    "id": "#main/repo"
                },
                {
                    "type": [
                        "string",
                        {
                            "type": "array",
                            "items": "string"
                        }
                    ],
                    "label": "list of SRA Run ID e.g. SRR1274307",
                    "doc": "list of SRA Run ID e.g. SRR1274307",
                    "id": "#main/run_ids"
                }
            ],
            "outputs": [
                {
                    "type": {
                        "type": "array",
                        "items": "File"
                    },
                    "outputSource": "#main/fasterq_dump/fastqFiles",
                    "id": "#main/fastq_files"
                }
            ],
            "steps": [
                {
                    "run": "#download-sra.cwl",
                    "in": [
                        {
                            "source": "#main/repo",
                            "id": "#main/download_sra/repo"
                        },
                        {
                            "source": "#main/run_ids",
                            "id": "#main/download_sra/run_ids"
                        }
                    ],
                    "out": [
                        "#main/download_sra/sraFiles"
                    ],
                    "id": "#main/download_sra"
                },
                {
                    "run": "#fasterq-dump.cwl",
                    "in": [
                        {
                            "source": "#main/nthreads",
                            "id": "#main/fasterq_dump/nthreads"
                        },
                        {
                            "source": "#main/download_sra/sraFiles",
                            "id": "#main/fasterq_dump/sraFiles"
                        }
                    ],
                    "out": [
                        "#main/fasterq_dump/fastqFiles"
                    ],
                    "id": "#main/fasterq_dump"
                }
            ],
            "id": "#main",
            "https://schema.org/license": "https://spdx.org/licenses/Apache-2.0",
            "https://schema.org/codeRepository": "https://github.com/pitagora-network/pitagora-cwl"
        }
    ],
    "cwlVersion": "v1.0",
    "$schemas": [
        "http://edamontology.org/EDAM_1.18.owl",
        "https://schema.org/version/latest/schemaorg-current-http.rdf"
    ]
}