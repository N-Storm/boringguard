Building boringtun-cli packages from source
===========================================

Following build instructions have been tested on Debian 11 Linux.

- Install [Rust](https://www.rust-lang.org/tools/install) will all required build essentials (gcc, make & autotools, etc).
- *If needed to build cross-compiled packages*: 
  - Install cross-compiling toolchain for target architecture. I've used Debian-bundled `gcc-arm-linux-gnueabihf` and `gcc-aarch64-linux-gnu` for glibc builds,
    and [toolchains from [toolchains.bootlin.com](https://toolchains.bootlin.com/) for ARM [musl](https://www.musl-libc.org/) builds.
  - Install Rust target platforms with `rustup target add <target>`. You can check targets list here: https://doc.rust-lang.org/nightly/rustc/platform-support.html.

# TODO: WiP, doc unfinished.

# x86_64, TARGET=HOST, normal build
cargo build --bin boringtun-cli --release
cargo deb -p boringtun-cli -v --no-build
cargo generate-rpm -p boringtun-cli --payload-compress gzip

# x86_64, use Musl (instead of glibc)
cargo build --target x86_64-unknown-linux-musl  --bin boringtun-cli --release
cargo deb -p boringtun-cli -v --no-build --target x86_64-unknown-linux-musl --deb-revision musl
cargo generate-rpm -p boringtun-cli --payload-compress gzip --target x86_64-unknown-linux-musl --variant=musl

# ARMv7, GNU EABI HF
CARGO_TARGET_ARMV7_UNKNOWN_LINUX_GNUEABIHF_LINKER=arm-linux-gnueabihf-gcc  cargo build --bin boringtun-cli --release --target armv7-unknown-linux-gnueabihf
cargo deb -p boringtun-cli -v --no-build --target armv7-unknown-linux-gnueabihf
cargo generate-rpm -p boringtun-cli --payload-compress gzip --target armv7-unknown-linux-gnueabihf

# ARMv7, MUSL EABI HF
CC='~/armv7-eabihf--musl--stable-2023.08-1/bin/arm-buildroot-linux-musleabihf-gcc' CARGO_TARGET_ARMV7_UNKNOWN_LINUX_MUSLEABIHF_LINKER="/home/nstorm/armv7-eabihf--musl--stable-2023.08-1/bin/arm-buildroot-linux-musleabihf-gcc" cargo build --bin boringtun-cli --release --target armv7-unknown-linux-musleabihf
cargo deb -p boringtun-cli -v --no-build --target armv7-unknown-linux-musleabihf --deb-revision musl
cargo generate-rpm -p boringtun-cli --payload-compress gzip --target armv7-unknown-linux-musleabihf --variant musl
