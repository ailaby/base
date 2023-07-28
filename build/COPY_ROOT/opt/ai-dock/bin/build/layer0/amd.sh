#!/bin/bash

# Must exit and fail to build if any command fails
set -e

if [[ -z $ROCM_VERSION ]]; then
    printf "No valid ROCM_VERSION specified\n" >&2
    exit 1
fi

printf "ROCM_VERSION=%s\n" ${ROCM_VERSION} > /root/.bashrc

curl -Ss https://repo.radeon.com/rocm/rocm.gpg.key | gpg --dearmor | tee /etc/apt/keyrings/rocm.gpg > /dev/null

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/${ROCM_VERSION} jammy main" \
    | tee --append /etc/apt/sources.list.d/rocm.list
echo -e 'Package: *\nPin: release o=repo.radeon.com\nPin-Priority: 600' \
    | tee /etc/apt/preferences.d/rocm-pin-600

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/amdgpu/${ROCM_VERSION}/ubuntu jammy main" \
    | tee --append /etc/apt/sources.list.d/rocm.list

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/amdgpu/${ROCM_VERSION}/ubuntu jammy proprietary" \
    | tee --append /etc/apt/sources.list.d/rocm.list

apt-get update

if [[ "${ROCM_LEVEL}" == "core" ]]; then
    $APT_INSTALL rocm-core

elif [[ "${ROCM_LEVEL}" == "runtime" ]]; then
    $APT_INSTALL rocm-opencl-runtime \
                 rocm-hip-runtime

elif [[ "${ROCM_LEVEL}" == "devel" ]]; then
    $APT_INSTALL rocm-libs \
                 rocm-opencl-sdk \
                 rocm-hip-sdk

else
    printf "No valid ROCM_LEVEL specified\n" >&2
    exit 1
fi