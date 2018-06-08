#!/bin/bash
# kallisto.sh <path to data dir> <path to index file> <path to kallisto.cwl> <path to kallisto.yml.sample>
#
set -e

get_abs_path(){
  local ipt="${1}"
  echo "$(cd $(dirname "${ipt}") && pwd -P)/$(basename "${ipt}")"
}

set_ncpus(){
  NCPUS=1
  if [[ "$(uname)" == 'Darwin' ]]; then
    NCPUS=$(sysctl -n hw.ncpu)
  elif [[ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]]; then
    NCPUS=$(nproc)
  else
    echo "Your platform ($(uname -a)) is not supported." 2>dev/null
    exit 1
  fi
}
set_ncpus

BASE_DIR="$(pwd -P)"
DATA_DIR_PATH="$(get_abs_path ${1})"
INDEX_FILE_PATH="$(get_abs_path ${2})"
CWL_PATH="$(get_abs_path ${3})"
YAML_TMP_PATH="$(get_abs_path ${4})"

find "${DATA_DIR_PATH}" -name '*.fastq*' | while read fpath; do
  id="$(basename "${fpath}" | sed -e 's:.fastq*$::g')"
  result_dir="${BASE_DIR}/result/${id:0:6}/${id}"
  mkdir -p "${result_dir}" && cd "${result_dir}"

  yaml_path="${result_dir}/${id}.yml"
  cp "${YAML_TMP_PATH}" "${yaml_path}"

  sed -r \
    -i.buk \
    -e "s:_INDEX_FILE_PATH_:${INDEX_FILE_PATH}:" \
    -e "s:_FASTQ_PATH_:${fpath}:" \
    -e "s:_NUM_CPUS_:${NCPUS}:" \
    -e "s:^# (.*)# UNCOMMENT FOR --single:\1:g" \
    "${yaml_path}"

  cwltool \
    --debug \
    --leave-container \
    --timestamps \
    --compute-checksum \
    --record-container-id \
    --cidfile-dir ${result_dir} \
    --outdir ${result_dir} \
    ${CWL_PATH} \
    "${yaml_path}" \
    2> "${result_dir}/cwltool.log"

  cd "${BASE_DIR}"
done
