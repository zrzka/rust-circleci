FROM debian:stretch

# Install additional packages
RUN apt-get update && \
    apt-get install -y curl file gcc g++ git make openssh-client \
    autoconf automake cmake libtool libcurl4-openssl-dev libssl-dev \
    libelf-dev libdw-dev binutils-dev zlib1g-dev libiberty-dev wget \
    xz-utils pkg-config python libssl-dev

# Image arguments
ARG rust_stable_version
ARG rust_nightly_version
ARG clippy_commit_hash
    
# Set environment variables
ENV PATH "$PATH:/root/.cargo/bin"
ENV CFG_RELEASE_CHANNEL "stable"

# Environment variables specific to this image
ENV RUST_STABLE_VERSION $rust_stable_version
ENV RUST_NIGHTLY_VERSION $rust_nightly_version
ENV CLIPPY_COMMIT_HASH $clippy_commit_hash

# Stable Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain=${RUST_STABLE_VERSION} && \
    bash -l -c 'echo $(rustc --print sysroot)/lib >> /etc/ld.so.conf' && \
    bash -l -c 'echo /usr/local/lib >> /etc/ld.so.conf' && \
    ldconfig

# Nightly & Clippy & rustfmt-preview
RUN rustup toolchain install ${RUST_NIGHTLY_VERSION} && \
    rustup component add --toolchain $RUST_NIGHTLY_VERSION rustfmt-preview && \
    which rustfmt || cargo install --force rustfmt-nightly && \
    cargo +${RUST_NIGHTLY_VERSION} install --force --git=https://github.com/rust-lang-nursery/rust-clippy \
        --rev=${CLIPPY_COMMIT_HASH} clippy
