#!/bin/bash
# rsem-calculate-expression_pe.sh <path to data dir> <path to reference index file (e.g. hoge.idx.fa)> <path to rsem-calculate-expression.cwl> <path to rsem-calculate-expression.yml.sample>
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

run_rsem_pe(){
  local fpath="${1}"
  local id=$(basename "${fpath}" | sed 's:.fastq.*$::g' | sed 's:_.$::g')
  local result_dir="${BASE_DIR}/result/${id:0:6}/${id}"
  local yaml_path="${result_dir}/${id}.yaml"

  case "${fpath}" in
    *_1.fastq*)
      # Paired End
      mkdir -p "${result_dir}" && cd "${result_dir}"
      config_yaml_paired_end "${yaml_path}" "${fpath}"
      run_cwl "${result_dir}" "${yaml_path}"
      ;;
  esac

  cd "${BASE_DIR}"
}

config_yaml_paired_end(){
  local yaml_path="${1}"
  local path_fwd="${2}"
  local path_rev="$(echo "${path_fwd}" | sed 's:_1.fastq:_2.fastq:')"

  local idx_basedir=$(dirname ${INDEX_FILE_PATH})
  local idx_basename=$(basename ${INDEX_FILE_PATH} | sed 's:\..*$::g')

  cp "${YAML_TMP_PATH}" "${yaml_path}"
  sed -E \
    -i.buk \
    -e "s:_PATH_TO_INDEX_DIR_:${idx_basedir}:" \
    -e "s:_RSEM_INDEX_PREFIX_:${idx_basename}:" \
    -e "s:_PATH_TO_FORWARD_FASTQ_:${path_fwd}:" \
    -e "s:_PATH_TO_REVERSE_FASTQ_:${path_rev}:" \
    -e "s:_PREFIX_:${id}:" \
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
  run_rsem_pe "${fpath}"
done
