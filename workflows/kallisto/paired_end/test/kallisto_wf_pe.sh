#!/bin/bash
# kallisto_wf_pe.sh [--id <path to id list>] [--kallisto-index <path to kallisto index file>] [--cwl <path to kallisto_wf_pe.cwl>] [--yml <path to kallisto_wf_pe.yaml.sample>]
#
set -e

get_abs_path(){
  echo "$(cd $(dirname "${1}") && pwd -P)/$(basename "${1}")"
}

case "$(uname -s)" in
  Darwin) NCPUS=$(sysctl -n hw.ncpu) ;;
  Linux ) NCPUS=$(nproc) ;;
  * ) NCPUS=1 ;;
esac

PFX=$(basename ${0} | sed 's:\.sh$::')

BASE_DIR="$(pwd -P)"
DATA_DIR_PATH="${BASE_DIR}"
CWL_PATH="${BASE_DIR}/${PFX}.cwl"
YAML_TMP_PATH="${BASE_DIR}/${PFX}.yml.sample"
ID_LIST_PATH="${BASE_DIR}/id.list"
KALLISTO_INDEX_FILE_PATH="${BASE_DIR}/kallisto_GRCh38"

while test $# -gt 0; do
  key=${1}
  case ${key} in
    --cwl) CWL_PATH="$(get_abs_path ${2})"; shift ;;
    --yml) YAML_TMP_PATH="$(get_abs_path ${2})"; shift ;;
    --id) ID_LIST_PATH="$(get_abs_path ${2})"; shift ;;
    --kallisto-index) KALLISTO_INDEX_FILE_PATH="$(get_abs_path ${2})"; shift ;;
  esac
  shift
done

run_workflow(){
  local id="${1}"
  local result_dir="${BASE_DIR}/result/${id:0:6}/${id}"
  local yaml_path="${result_dir}/${id}.yaml"
  mkdir -p "${result_dir}" && cd "${result_dir}"

  config_yaml "${yaml_path}" "${id}"

  run_cwl "${result_dir}" "${yaml_path}"
  cd "${BASE_DIR}"
}

config_yaml(){
  local yaml_path="${1}"
  local id="${2}"
  cp "${YAML_TMP_PATH}" "${yaml_path}"
  sed -E \
    -i.buk \
    -e "s:_NTHREADS_:${NCPUS}:" \
    -e "s:_RUN_ID_:${id}:" \
    -e "s:_INDEX_FILE_PATH_:${KALLISTO_INDEX_FILE_PATH}:" \
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
  run_workflow "${run_id}" ||:
done
