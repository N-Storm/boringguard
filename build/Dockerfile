# 1. This tells docker to use the Rust official image
FROM rust:1.88.0 AS builder

# Installing prerequisites & boringtun source tree
WORKDIR /usr/src
RUN echo "Installing prerequisites & boringtun source tree"; \
 apt update && \
 apt install -y gcc-12-aarch64-linux-gnu musl musl-dev musl-tools wget curl rpm xz-utils && \
 rustup target add x86_64-unknown-linux-musl  armv7-unknown-linux-musleabihf aarch64-unknown-linux-gnu aarch64-unknown-linux-musl && \
 cargo install cargo-deb cargo-generate-rpm && \
 git clone https://github.com/cloudflare/boringtun

# Downloading ARM toolchains from toolchains.bootlin.com...
WORKDIR /opt
RUN echo "Downloading ARM toolchains from toolchains.bootlin.com..."; \
 curl -O "https://toolchains.bootlin.com/downloads/releases/toolchains/aarch64/tarballs/aarch64--musl--stable-2024.05-1.tar.xz" || wget "https://toolchains.bootlin.com/downloads/releases/toolchains/aarch64/tarballs/aarch64--musl--stable-2024.05-1.tar.xz" && \
 curl -O "https://toolchains.bootlin.com/downloads/releases/toolchains/armv7-eabihf/tarballs/armv7-eabihf--musl--stable-2024.05-1.tar.xz" || wget "https://toolchains.bootlin.com/downloads/releases/toolchains/armv7-eabihf/tarballs/armv7-eabihf--musl--stable-2024.05-1.tar.xz"
RUN echo "Unpacking toolchains"; \
 tar xf aarch64--musl--stable-2024.05-1.tar.xz && tar xf armv7-eabihf--musl--stable-2024.05-1.tar.xz

# Checkout last stable version 0.5.2 & apply patch to fix cross-compiling and package building
WORKDIR /usr/src/boringtun
COPY multiarch-multipackage.patch ./
RUN git checkout tags/boringtun-cli-0.5.2 && patch -p1 < multiarch-multipackage.patch

# Build binaries & packages for different archs
# x86_64 glibc
RUN cargo build --bin boringtun-cli --release && \
 cargo deb -p boringtun-cli -v --no-build --deb-revision '' && \
 cargo generate-rpm -p boringtun-cli --payload-compress gzip

# x84_64 musl
RUN cargo build --target x86_64-unknown-linux-musl --bin boringtun-cli --release && \
 cargo deb -p boringtun-cli -v --no-build --target x86_64-unknown-linux-musl --deb-revision musl && \
 cargo generate-rpm -p boringtun-cli --payload-compress gzip --target x86_64-unknown-linux-musl --variant=musl

# ARMv7 HardFloat musl
RUN CC='/opt/armv7-eabihf--musl--stable-2024.05-1/bin/arm-buildroot-linux-musleabihf-gcc' CARGO_TARGET_ARMV7_UNKNOWN_LINUX_MUSLEABIHF_LINKER='/opt/armv7-eabihf--musl--stable-2024.05-1/bin/arm-buildroot-linux-musleabihf-gcc' cargo build --bin boringtun-cli --release --target armv7-unknown-linux-musleabihf && \
 cargo deb -p boringtun-cli -v --no-build --target armv7-unknown-linux-musleabihf --deb-revision musl && \
 cargo generate-rpm -p boringtun-cli --payload-compress gzip --target armv7-unknown-linux-musleabihf --variant musl

# ARMv8 (aarch64) glibc
RUN CC='aarch64-linux-gnu-gcc-12' cargo build --bin boringtun-cli --release --target aarch64-unknown-linux-gnu && \
 cargo deb -p boringtun-cli -v --no-build --target aarch64-unknown-linux-gnu --deb-revision '' && \
 cargo generate-rpm -p boringtun-cli --payload-compress gzip --target aarch64-unknown-linux-gnu

# ARMv8 (aarch64) musl
RUN CC='/opt/aarch64--musl--stable-2024.05-1/bin/aarch64-buildroot-linux-musl-gcc' CARGO_TARGET_AARCH64_UNKNOWN_LINUX_MUSL_LINKER='/opt/aarch64--musl--stable-2024.05-1/bin/aarch64-buildroot-linux-musl-gcc' cargo build --bin boringtun-cli --release --target aarch64-unknown-linux-musl && \
 cargo deb -p boringtun-cli -v --no-build --target aarch64-unknown-linux-musl --deb-revision musl && \
 cargo generate-rpm -p boringtun-cli --payload-compress gzip --target aarch64-unknown-linux-musl --variant musl
