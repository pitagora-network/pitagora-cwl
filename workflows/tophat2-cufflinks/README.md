# tophat2-cufflinks workflow

## Test

Single-end input version:

```
$ curl https://raw.githubusercontent.com/pitagora-galaxy/cwl/master/test/bin/run-cwl | bash -s "tophat2-cufflinks_wf_se"
```

Paired-end input version:

```
$ curl https://raw.githubusercontent.com/pitagora-galaxy/cwl/master/test/bin/run-cwl | bash -s "tophat2-cufflinks_wf_pe"
```

### Steps

1. [download-sra](/tools/download-sra)
2. [pfastq-dump](/tools/pfastq-dump)
3. [tophat2-mapping](/tools/tophat2/mapping)
4. [cufflinks](/tools/cufflinks)
