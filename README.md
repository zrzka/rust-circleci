# Rust CI

Docker test & build image for Rust projects. This image contains:

* stable version of Rust (as default toolchain),
* specific nightly version of Rust,
* clippy version compatible with nightly version of Rust.

Every image is tagged with Rust stable version (`zrzka/rust-circleci:1.26.2`
for example). Latest version is tagged with `zrzka/rust-circleci:latest`. All released
versions are available [here](https://github.com/zrzka/rust-circleci/releases).

Why specific nightly version? That's because of
[Clippy](https://github.com/rust-lang-nursery/rust-clippy). Rust compiler evolves
and Clippy doesn't compile / work on these nightly builds from time to time.

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

## Update

Steps for new Rust version update:

* modify [local.env](local.env),
* build with [build.sh](build.sh) script,
* check and inspect image locally,
* push with [push.sh](push.sh) script.
