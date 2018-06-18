# kallisto workflow

## Test

Single-end input version:

```
$ curl https://raw.githubusercontent.com/pitagora-galaxy/cwl/master/test/bin/run-cwl | bash -s "kallisto_wf_se"
```

Paired-end input version:

```
$ curl https://raw.githubusercontent.com/pitagora-galaxy/cwl/master/test/bin/run-cwl | bash -s "kallisto_wf_pe"
```

### Steps

1. [download-sra](/tools/download-sra)
2. [pfastq-dump](/tools/pfastq-dump)
3. [kallisto-quant](/tools/kallisto/quant)
