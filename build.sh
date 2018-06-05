#!/usr/bin/env bash

set -e

export RUST_VERSION=$(cat rust.version)

docker build . \
  -t zrzka/rust-circleci:latest \
  -t zrzka/rust-circleci:${RUST_VERSION} \
  --build-arg "rust_version=${RUST_VERSION}"

docker push zrzka/rust-circleci:latest
docker push zrzka/rust-circleci:${RUST_VERSION}
