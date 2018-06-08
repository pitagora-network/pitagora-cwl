#!/bin/sh
#!/bin/bash
# download-sra.sh <path to id.list> <path to download-sra.cwl> <path to download-sra.yml.sample>
#
set -e

BASE_DIR="$(pwd -P)"
ID_LIST_PATH="${1}"
CWL_PATH="$(cd $(dirname "${2}") && pwd -P)/$(basename "${2}")"
YAML_TMP_PATH="$(cd $(dirname "${3}") && pwd -P)/$(basename "${3}")"

cat "${ID_LIST_PATH}" | while read id; do
  result_dir="${BASE_DIR}/result/${id:0:6}/${id}"
  mkdir -p "${result_dir}" && cd "${result_dir}"

  yaml_path="${result_dir}/${id}.yml"
  cp "${YAML_TMP_PATH}" "${yaml_path}"

  sed -i.buk \
    -e "s:_RUN_IDS_:${id}:" \
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
