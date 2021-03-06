#!/usr/bin/env bash

set -x
set -e

RECSYS_ROOT=.
RECSYS_OUTPUT_DIR=${RECSYS_ROOT}/_output
GIT_VERSION=$(git describe --tags `git rev-list --tags --max-count=1`)
GIT_COMMIT=$(git rev-parse --short HEAD)
DEFAULT_BASE_GPU_IMAGE="nvidia/cuda:10.1-cudnn8-runtime-ubuntu18.04"
DEFAULT_BASE_CPU_IMAGE="ubuntu:18.04"

readonly -a BUILD_TARGET=(
#   cpu
  gpu
)
readonly -a targets=(${WHAT:-${BUILD_TARGET[@]}})
readonly -a gpu_image=(${BASE_GPU_IMAGE:-${DEFAULT_BASE_GPU_IMAGE}})
readonly -a cpu_image=(${BASE_CPU_IMAGE:-${DEFAULT_BASE_CPU_IMAGE}})



function build_docker_images(){
  for t in "${targets[@]}"; do
    if [ "$t" == "gpu" ]; then
      BASE_IMAGE=${gpu_image}
      RECSYS_IMAGE="cambridgeltl/glances:${GIT_VERSION}-${GIT_COMMIT}-gpu"
    else
      BASE_IMAGE=${cpu_image}
      RECSYS_IMAGE="cambridgeltl/glances:${GIT_VERSION}-${GIT_COMMIT}"
    fi
      BASE_IMAGE=${gpu_image}
    docker build --no-cache --build-arg BASE_IMAGE="$BASE_IMAGE" -t "${RECSYS_IMAGE}" -f "${RECSYS_ROOT}/Dockerfile" ${RECSYS_ROOT}
  done
}
echo "build result: ${RECSYS_IMAGE}"
build_docker_images
