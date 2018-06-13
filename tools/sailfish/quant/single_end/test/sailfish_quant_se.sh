#!/bin/bash
# sailfish_quant_se.sh <path to data dir> <path to index dir> <path to sailfish_quant_se.cwl> <path to sailfish_quant_se.yaml.sample>
#
set -e

get_abs_path(){
  echo "$(cd $(dirname "${1}") && pwd -P)/$(basename "${1}")"
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
INDEX_DIR_PATH="$(get_abs_path ${2})"
CWL_PATH="$(get_abs_path ${3})"
YAML_TMP_PATH="$(get_abs_path ${4})"

run_sailfish_quant_se(){
  local fpath="${1}"
  local id=$(basename "${fpath}" | sed 's:.fastq.*$::g' | sed 's:_.$::g')
  local result_dir="${BASE_DIR}/result/${id:0:6}/${id}"
  local yaml_path="${result_dir}/${id}.yaml"

  mkdir -p "${result_dir}" && cd "${result_dir}"
  config_yaml_single_end "${yaml_path}" "${fpath}"
  run_cwl "${result_dir}" "${yaml_path}"

  cd "${BASE_DIR}"
}

config_yaml_single_end(){
  local yaml_path="${1}"
  local fpath="${2}"

  cp "${YAML_TMP_PATH}" "${yaml_path}"
  sed -r \
    -i.buk \
    -e "s:_PATH_TO_SAILFISH_INDEX_DIR_:${INDEX_DIR_PATH}:" \
    -e "s:_PATH_TO_FASTQ_:${fpath}:" \
    -e "s:_NTHREADS_:${NCPUS}:" \
    "${yaml_path}"
}

run_cwl(){
  local result_dir="${1}"
  local yaml_path="${2}"
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
}

find "${DATA_DIR_PATH}" -name '*.fastq*' | while read fpath; do
  run_sailfish_quant_se "${fpath}"
done
