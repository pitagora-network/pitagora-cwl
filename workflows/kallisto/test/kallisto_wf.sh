#!/bin/bash
# kallisto_wf.sh <path to id list> <path to kallisto index file> <path to kallisto_wf.cwl> <path to kallisto_wf.yaml.sample> [single|paired]
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
ID_LIST_PATH="$(get_abs_path ${1})"
INDEX_FILE_PATH="$(get_abs_path ${2})"
CWL_PATH="$(get_abs_path ${3})"
YAML_TMP_PATH="$(get_abs_path ${4})"
READ_LAYOUT="${5}"

run_workflow(){
  local id="${1}"
  local result_dir="${BASE_DIR}/result/${id:0:6}/${id}"
  local yaml_path="${result_dir}/${id}.yaml"
  mkdir -p "${result_dir}" && cd "${result_dir}"

  case "${READ_LAYOUT}" in
    "single" | "SE" | "SINGLE" )
      config_yaml_single_end "${yaml_path}" "${id}"
      ;;
    "paired" | "PE" | "PAIRED" )
      config_yaml_paired_end "${yaml_path}" "${id}"
      ;;
    *)
      echo "ERROR: Read Layout not specified"
      echo "usage: kallisto_wf.sh <path to id list> <path to kallisto index file> <path to kallisto_wf.cwl> <path to kallisto_wf.yaml.sample> [single|paired]"
      exit 1
      ;;
  esac

  run_cwl "${result_dir}" "${yaml_path}"
  cd "${BASE_DIR}"
}

config_yaml_single_end(){
  local yaml_path="${1}"
  local id="${2}"
  cp "${YAML_TMP_PATH}" "${yaml_path}"
  sed -r \
    -i.buk \
    -e "s:_NTHREADS_:${NCPUS}:" \
    -e "s:_RUN_IDS_:${id}:" \
    -e "s:_INDEX_FILE_PATH_:${INDEX_FILE_PATH}:" \
    -e "s:^# (.*)# UNCOMMENT FOR --single:\1:g" \
    "${yaml_path}"
}

config_yaml_paired_end(){
  local yaml_path="${1}"
  local id="${2}"
  cp "${YAML_TMP_PATH}" "${yaml_path}"
  sed -r \
    -i.buk \
    -e "s:_NTHREADS_:${NCPUS}:" \
    -e "s:_RUN_IDS_:${id}:" \
    -e "s:_INDEX_FILE_PATH_:${INDEX_FILE_PATH}:" \
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

cat "${ID_LIST_PATH}" | while read run_id; do
  run_workflow "${run_id}"
done
