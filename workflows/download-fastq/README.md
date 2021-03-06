# Download FASTQ file from the Sequence Read Archive

## Prerequisites

- Docker
- [`cwltool`](https://github.com/common-workflow-language/cwltool) or [your favorite CWL runner](https://www.commonwl.org/cwl-staging/#Implementations)
  - with the option `--no-match-user` to run containers as root

### For singularity users

The NCBI's file format converter `fasterq-dump` in `sra-tools` has an issue when one runs it in non-interactive environment like this automated CWL workflow. The tool requires the configuration of its setting with `vdb-config` beforehand, saving the configuration file at `$HOME/.ncbi/user-settings.mkfg`. The official Docker container has a configuration file in the container's file system to avoid this issue, but the configuration file is at `/root/.ncbi/user-settings.mkfg`, which means that the users need to run the container as root user. This is not a recommended way to use Docker container in terms of keeping the container's security though.

This problem, however, becomes worse when the workflow runs with `cwltool --singularity`. In the CWL specification, the runtime environment has to be distinct from the host environment to ensure workflow portability, which means runtime environment has different `$HOME` path and it cannot be changed (and it shouldn't be from the view of reproducibility).

There's not a practical way to run this workflow with singularity for now, but here's a procedure to run `fasterq-dump` with singularity:

```
$ singularity pull docker://ncbi/sra-tools:2.11.0
$ singularity exec sra-tools_2.11.0.sif vdb-config --interactive
# You can just save and exit, the config file will be saved at $HOME/.ncbi/user-settings.mkfg
$ singularity exec sra-tools_2.11.0.sif fasterq-dump SRR1274306.sra --threads 8 --skip-technical --split-files --split-spot
```
You can download SRA format files with [`download-sra.cwl`](../../tools/download-sra/download-sra.cwl).

## Workflows

- `download-fastq.cwl`
  - Accept a list of SRA Run IDs
- `download-fastq.single.cwl`
  - Accept a single SRA Run ID

## Inputs

- `run_id` (`download-fastq.single.cwl`) or `run_ids` (`download-fastq.cwl`)
  - Sequence Read Archive Run ID (e.g. `SRR1274306`)
  - You can find the ID by keywords with online search tools
    - NCBI Run Selector: https://www.ncbi.nlm.nih.gov/Traces/study/
    - DBCLS SRA: http://sra.dbcls.jp/
- `repo`
  - The archive to be used
  - `ncbi`, `ebi`, or `ddbj` (default: `ebi`)
- `nthreads`
  - the number of threads to use for parallel decompression of SRA format data

## Usage

### Download single Run data

Use `download-fastq.single.cwl`. You can specify `run_id` via command line argument:

```
$ cwltool --no-match-user "https://raw.githubusercontent.com/pitagora-network/pitagora-cwl/master/workflows/download-fastq/download-fastq.single.cwl" --run_id "SRR1274307"
```

Or specify via job configuration file:

```
$ cat job.yaml
run_id: SRR1274306
$ cwltool --no-match-user "https://raw.githubusercontent.com/pitagora-network/pitagora-cwl/master/workflows/download-fastq/download-fastq.single.cwl" job.yaml
```

### Download multiple Run data

Use `download-fastq.cwl`. Make sure to use job config file to specify `run_ids` for multiple run IDs:

```
$ cat job.yaml
run_ids:
  - SRR1274306
  - SRR1274307
$ cwltool --no-match-user "https://raw.githubusercontent.com/pitagora-network/pitagora-cwl/master/workflows/download-fastq/download-fastq.cwl" "job.yml"
```

Note: `cwltool` does not handle `string[]` type input via command line argument, so you always need to specify via job conf.

### Tips

You can download the CWL definition file and run locally:

```
$ curl -o "download-fastq.cwl" "https://raw.githubusercontent.com/pitagora-network/pitagora-cwl/master/workflows/download-fastq/download-fastq.single.cwl"
$ cwltool download-fastq.cwl --run_id "SRR1274307"
```

Use cwltool via docker container:

```
$ curl -o "download-fastq.cwl" "https://raw.githubusercontent.com/pitagora-network/pitagora-cwl/master/workflows/download-fastq/download-fastq.single.cwl"
$ ls
download-fastq.cwl
$ docker run -ti -w /work -v $(pwd):/work -v /tmp:/tmp -v /var/run/docker.sock:/var/run/docker.sock quay.io/inutano/cwltool:1.0.20180820141117-alpine3.8 sh
$ cwltool "download-fastq.single.cwl" --run_id "SRR1274307"
```

## Troubleshooting

The `download-fastq` workflow pulls data from the EBI FTP server by default, but sometimes you cannot download a file for some reasons. You can change the repository by adding the option `--repo`

```
$ cwltool "https://raw.githubusercontent.com/pitagora-network/pitagora-cwl/master/workflows/download-fastq/download-fastq.single.cwl" --run_id "SRR1274306" --repo "ncbi"
```

Or you can edit the job conf YAML file.

```
$ cat job.yaml
run_id: SRR1274306
repo: "ncbi"
$ cwltool "https://raw.githubusercontent.com/pitagora-network/pitagora-cwl/master/workflows/download-fastq/download-fastq.single.cwl" job.yaml
```
