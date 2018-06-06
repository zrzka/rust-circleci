#!/usr/bin/env bash

set -e

source ./local.env

docker push zrzka/rust-circleci:latest
docker push zrzka/rust-circleci:${RUST_STABLE_VERSION}
