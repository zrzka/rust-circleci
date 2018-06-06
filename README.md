# Rust CI

Docker test & build image for Rust projects. This image contains:

* stable version of Rust (as default toolchain),
* nightly version of Rust,
* clippy version compatible with nightly version of Rust.

Every image is tagged with Rust stable version (`zrzka/rust-circleci:1.26.1`).

## Latest version

Tagged as `zrzka/rust-circleci:latest` and it contains following versions:

```bash
RUST_STABLE_VERSION=1.26.1
RUST_NIGHTLY_VERSION=nightly-2018-04-30
CLIPPY_COMMIT_HASH=77de1000d7ecb2419bf3402905c926bbcd588aba
```

Nightly evolves faster than clippy sometimes and clippy is not buildable. That's
the reason why we stick with specific nightly version and clippy commit hash.

## Usage

### Dockerfile

```
FROM zrzka/rust-circleci:1.26.1 as builder
COPY . /src
WORKDIR /src
RUN scripts/ci/test-and-build.sh

FROM debian:stretch
RUN apt-get update && apt-get -y install ca-certificates && rm -rf /var/lib/apt/lists/*
RUN mkdir /app
COPY --from=builder /src/target/release/your-app-name /app/your-app-name

CMD /app/your-app-name
```

### Sample Build Script

You can use `RUST_STABLE_VERSION`, `RUST_NIGHTLY_VERSION` and `CLIPPY_COMMIT_HASH`
environment variables in your script. Here's the sample test and build script.

```bash
#!/usr/bin/env bash

set -e
set -x

#
# Don't use rustup & cargo +toolchain here, default version is stable and is specified
# by the docker image (see Dockerfile & FROM).
#

echo "Build environment..."
rustc --version --verbose
cargo --version --verbose

#
# Check formatting of the code and run Clippy (linter).
#
if [ -z ${RUST_NIGHTLY_VERSION+x} ]; then
    echo "RUST_NIGHTLY_VERSION not set, skipping clippy and formatting checks"
else
    cargo +${RUST_NIGHTLY_VERSION} fmt --all -- --write-mode diff
    cargo +${RUST_NIGHTLY_VERSION} clippy
fi

# Run tests with --release, just to speed up following cargo
# build with --release flag as well

cargo test --release
cargo build --release
```
