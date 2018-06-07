#!/usr/bin/env bash

set -e

source ./local.env

docker push zrzka/rust-circleci:stable
docker push zrzka/rust-circleci:${RUST_STABLE_VERSION}
