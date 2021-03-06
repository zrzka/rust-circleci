#!/usr/bin/env bash

set -e

source ./local.env

docker build . \
  -t zrzka/rust-circleci:stable \
  -t zrzka/rust-circleci:${RUST_STABLE_VERSION} \
  --build-arg "rust_stable_version=${RUST_STABLE_VERSION}" \
  --build-arg "rust_nightly_version=${RUST_NIGHTLY_VERSION}" \
  --build-arg "clippy_commit_hash=${CLIPPY_COMMIT_HASH}"
