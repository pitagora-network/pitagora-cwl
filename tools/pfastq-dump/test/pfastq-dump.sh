#!/bin/bash
# pfastq-dump.sh <path to data dir> <path to pfastq-dump.cwl> <path to pfastq-dump.yml.sample>
#
set -e

BASE_DIR="$(pwd -P)"
DATA_DIR_PATH="${1}"
CWL_PATH="$(cd $(dirname "${2}") && pwd -P)/$(basename "${2}")"
YAML_TMP_PATH="$(cd $(dirname "${3}") && pwd -P)/$(basename "${3}")"

NCPUS=1
if [[ "$(uname)" == 'Darwin' ]]; then
  NCPUS=$(sysctl -n hw.ncpu)
elif [[ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]]; then
  NCPUS=$(nproc)
else
  echo "Your platform ($(uname -a)) is not supported." 2>dev/null
  exit 1
fi

find "${DATA_DIR_PATH}" -name '*.sra' | while read fpath; do
  id="$(basename "${fpath}" | sed -e 's:.sra$::g')"
  result_dir="${BASE_DIR}/result/${id:0:6}/${id}"

  mkdir -p "${result_dir}"

  data_path="${result_dir}/data.sra"
  ln -s "${fpath}" "${data_path}"

  cwl_path="${result_dir}/pfastq-dump.cwl"
  ln -s "${CWL_PATH}" "${cwl_path}"

  yaml_path="${result_dir}/${id}.yml"
  cp "${YAML_TMP_PATH}" "${yaml_path}"

  sed -i.buk \
    -e "s:_PATH_TO_SRA_FILE_:${fpath}:" \
    -e "s:_NTHREADS_:${NCPUS}:" \
    -e "s:_OUT_FASTQ_PREFIX_:${id}:" \
    "${yaml_path}"

  cd "${result_dir}"

  cwltool \
    --debug \
    --leave-container \
    --timestamps \
    --compute-checksum \
    --record-container-id \
    --cidfile-dir ${result_dir} \
    --outdir ${result_dir} \
    pfastq-dump.cwl \
    "${yaml_path}" \
    2> "${result_dir}/cwltool.log"

  cd "${BASE_DIR}"
done
