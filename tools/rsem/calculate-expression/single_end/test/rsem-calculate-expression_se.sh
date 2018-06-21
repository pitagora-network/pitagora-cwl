#!/bin/bash
# rsem-calculate-expression.sh <path to data dir> <path to reference index file (e.g. hoge.idx.fa)> <path to rsem-calculate-expression.cwl> <path to rsem-calculate-expression.yml.sample>
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
PATH_TO_INDEX_FILE="$(get_abs_path ${2})"
CWL_PATH="$(get_abs_path ${3})"
YAML_TMP_PATH="$(get_abs_path ${4})"

index_dir=$(dirname ${PATH_TO_INDEX_FILE})
index_prefix=$(basename ${PATH_TO_INDEX_FILE} | sed 's:\..*$::')

find "${DATA_DIR_PATH}" -name '*.fastq' | while read fpath; do
  id="$(basename "${fpath}" | sed -e 's:.bam$::g')"
  result_dir="${BASE_DIR}/result/${id:0:6}/${id}"
  mkdir -p "${result_dir}" && cd "${result_dir}"

  yaml_path="${result_dir}/${id}.yml"
  cp "${YAML_TMP_PATH}" "${yaml_path}"

  sed -i.buk \
    -e "s:_PATH_TO_INPUT_FASTQ_:${fpath}:" \
    -e "s:_PATH_TO_INDEX_DIR_:${index_dir}:" \
    -e "s:_RSEM_INDEX_PREFIX_:${index_prefix}:" \
    -e "s:_PREFIX_:${id}:" \
    "${yaml_path}"

  cwltool \
    --debug \
    --leave-container \
    --timestamps \
    --compute-checksum \
    --record-container-id \
    --cidfile-dir ${result_dir} \
    --outdir ${result_dir} \
    "${CWL_PATH}" \
    "${yaml_path}" \
    2> "${result_dir}/cwltool.log"

  cd "${BASE_DIR}"
done
