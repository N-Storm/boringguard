#!/bin/bash
# Build boringtun-cli packages from git sources

PACKAGES="target/debian/boringtun-cli_0.5.2_amd64.deb \
target/generate-rpm/boringtun-cli-0.5.2-1.x86_64.rpm \
target/x86_64-unknown-linux-musl/debian/boringtun-cli_0.5.2-musl_amd64.deb \
target/x86_64-unknown-linux-musl/generate-rpm/boringtun-cli-0.5.2-musl.x86_64.rpm \
target/armv7-unknown-linux-musleabihf/debian/boringtun-cli_0.5.2-musl_armhf.deb \
target/armv7-unknown-linux-musleabihf/generate-rpm/boringtun-cli-0.5.2-musl.armv7.rpm \
target/aarch64-unknown-linux-musl/debian/boringtun-cli_0.5.2-musl_arm64.deb \
target/aarch64-unknown-linux-musl/generate-rpm/boringtun-cli-0.5.2-musl.aarch64.rpm \
target/aarch64-unknown-linux-gnu/debian/boringtun-cli_0.5.2_arm64.deb \
target/aarch64-unknown-linux-gnu/generate-rpm/boringtun-cli-0.5.2-1.aarch64.rpm"

mkdir -p packages 2> /dev/null
docker build -t boringtun-builds $PWD

# Copy packages to host
docker run --rm --user "$(id -u)":"$(id -g)" -v "$PWD"/packages:/mnt/host -w /usr/src/boringtun boringtun-builds cp $PACKAGES /mnt/host/

