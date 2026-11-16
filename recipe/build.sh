#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == "1" ]]; then
  export "HOST_CC=${CC_FOR_BUILD}"
  export "HOST_CFLAGS=${CFLAGS_FOR_BUILD:-}"
  export "TARGET_CC=${CC:-}"
  export "TARGET_CFLAGS=${CFLAGS:-}"
  unset CC
  unset CFLAGS
fi

cargo install --no-track --locked --root "$PREFIX" --path ./cli --bin jj jj-cli

cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml
