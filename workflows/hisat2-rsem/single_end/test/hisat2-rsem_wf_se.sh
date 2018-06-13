#!/bin/bash
# hisat2-rsem_wf.sh <path to id list> <path to one of hisat2 index files (e.g. hoge.1.ht2)> <path to RSEM reference index file (e.g. hoge.idx.fa)> <path to hisat2-rsem_wf_(se|pe).cwl> <path to hisat2-rsem_wf_(se|pe).yaml.sample>
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

BASE_DIR="$(pwd -P)"
ID_LIST_PATH="$(get_abs_path ${1})"
HISAT2_INDEX_FILE_PATH="$(get_abs_path ${2})"
RSEM_INDEX_FILE_PATH="$(get_abs_path ${3})"
CWL_PATH="$(get_abs_path ${4})"
YAML_TMP_PATH="$(get_abs_path ${5})"

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

  local ht2_idx_basedir=$(dirname ${HISAT2_INDEX_FILE_PATH})
  local ht2_idx_basename=$(basename ${HISAT2_INDEX_FILE_PATH} | sed 's:\..*$::g')

  local rsem_idx_basedir=$(dirname ${RSEM_INDEX_FILE_PATH})
  local rsem_idx_prefix=$(basename ${RSEM_INDEX_FILE_PATH} | sed 's:\..*$::')

  sed -r \
    -i.buk \
    -e "s:_NTHREADS_:${NCPUS}:" \
    -e "s:_RUN_IDS_:${id}:" \
    -e "s:_HISAT2_INDEX_DIR_PATH_:${ht2_idx_basedir}:" \
    -e "s:_HISAT2_INDEX_BASENAME_:${ht2_idx_basename}:" \
    -e "s:_RSEM_INDEX_DIR_PATH_:${rsem_idx_basedir}:" \
    -e "s:_RSEM_INDEX_PREFIX_:${rsem_idx_prefix}:" \
    -e "s:_RSEM_OUT_PREFIX_:${id}:" \
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
