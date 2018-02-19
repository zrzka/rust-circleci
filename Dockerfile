FROM debian:stretch

RUN apt-get update && \  
    apt-get install -y curl file gcc g++ git make openssh-client \
    autoconf automake cmake libtool libcurl4-openssl-dev libssl-dev \
    libelf-dev libdw-dev binutils-dev zlib1g-dev libiberty-dev wget \
    xz-utils pkg-config python libssl-dev

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

ENV PATH "$PATH:/root/.cargo/bin"  
ENV RUSTFLAGS "-C link-dead-code"  
ENV CFG_RELEASE_CHANNEL "nightly"

RUN rustup update && \  
    rustup install nightly && \
    rustup default nightly

RUN bash -l -c 'echo $(rustc --print sysroot)/lib >> /etc/ld.so.conf'  
RUN bash -l -c 'echo /usr/local/lib >> /etc/ld.so.conf'  
RUN ldconfig
