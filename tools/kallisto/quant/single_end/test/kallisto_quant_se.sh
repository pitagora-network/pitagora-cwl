#!/bin/bash
# kallisto.sh <path to data dir> <path to index file> <path to kallisto.cwl> <path to kallisto.yaml.sample>
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
DATA_DIR_PATH="$(get_abs_path ${1})"
INDEX_FILE_PATH="$(get_abs_path ${2})"
CWL_PATH="$(get_abs_path ${3})"
YAML_TMP_PATH="$(get_abs_path ${4})"

run_kallisto(){
  local fpath="${1}"
  local id=$(basename "${fpath}" | sed 's:.fastq*$::g' | sed 's:_.$::g')
  local result_dir="${BASE_DIR}/result/${id:0:6}/${id}"
  local yaml_path="${result_dir}/${id}.yaml"

  case "${fpath}" in
    *_1.fastq*)
      # Paired End
      mkdir -p "${result_dir}" && cd "${result_dir}"
      config_yaml_paired_end "${yaml_path}" "${fpath}"
      run_cwl "${result_dir}" "${yaml_path}"
      ;;
    *_2.fastq*)
      # Do nothing
      ;;
    *)
      # Single End
      mkdir -p "${result_dir}" && cd "${result_dir}"
      config_yaml_single_end "${yaml_path}" "${fpath}"
      run_cwl "${result_dir}" "${yaml_path}"
      ;;
  esac

  cd "${BASE_DIR}"
}

config_yaml_single_end(){
  local yaml_path="${1}"
  local fpath="${2}"
  cp "${YAML_TMP_PATH}" "${yaml_path}"
  sed -E \
    -i.buk \
    -e "s:_INDEX_FILE_PATH_:${INDEX_FILE_PATH}:" \
    -e "s:_FASTQ_PATH_:${fpath}:" \
    -e "s:_NTHREADS_:${NCPUS}:" \
    -e "s:^# (.*)# UNCOMMENT FOR --single:\1:g" \
    "${yaml_path}"
}

config_yaml_paired_end(){
  local yaml_path="${1}"
  local path_fwd="${2}"
  local path_rev="$(echo "${path_fwd}" | sed 's:_1.fastq:_2.fastq:')"

  cp "${YAML_TMP_PATH}" "${yaml_path}.buk"
  cat "${yaml_path}.buk" | \
    sed -E \
      -e "s:_INDEX_FILE_PATH_:${INDEX_FILE_PATH}:" \
      -e "s:_NTHREADS_:${NCPUS}:" \
      -e "s#_FASTQ_PATH_#${path_fwd}@  - class: File@    path: ${path_rev}#" \
      "${yaml_path}" | \
    tr '@' '\n' \
    > "${yaml_path}"
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
  run_kallisto "${fpath}"
done
