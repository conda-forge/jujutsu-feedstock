#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == "1" ]]; then
  _host_triple="$(rustc -vV | sed -n 's/^host: //p' | tr '-' '_')"
  export "CC_${_host_triple}=${CC_FOR_BUILD}"
  export "CXX_${_host_triple}=${CXX_FOR_BUILD}"
  export "CFLAGS_${_host_triple}=${CFLAGS_FOR_BUILD:-}"
  export "CXXFLAGS_${_host_triple}=${CXXFLAGS_FOR_BUILD:-}"
  unset _host_triple
fi

cargo install --no-track --locked --root "$PREFIX" --path ./cli --bin jj jj-cli

cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml
