Building boringtun-cli Packages from Source
===========================================

This directory contains scripts to build [Boringtun](https://github.com/cloudflare/boringtun) from sources. It has been tested on Debian 11 & 12 but should also work on Ubuntu.
The entire build process is done within Docker containers and is as simple as running the `BUILD.sh` script. This script will download all prerequisites, including build tools, toolchains, etc.
Once built, the packages will be "extracted" from the container to the `./packages` directory.

The only requirement on the host is Docker and its dependencies. The `docker.io` package on Debian will require apparmor packages to build successfully.

Usage
-----

```bash
# Install Docker & apparmor:
sudo apt install docker.io apparmor apparmor-utils

# Add your user to the docker group to allow running containers:
sudo gpasswd -a $USER docker

# You must re-login now so group permissions can be applied.
# After that, just run the script from this directory:
./BUILD.sh
```

Once finished, it should build and place these packages in the ./packages directory:

```shell
boringtun-cli-0.5.2-1.aarch64.rpm
boringtun-cli-0.5.2-1.x86_64.rpm
boringtun-cli_0.5.2_amd64.deb
boringtun-cli_0.5.2_arm64.deb
boringtun-cli-0.5.2-musl.aarch64.rpm
boringtun-cli_0.5.2-musl_amd64.deb
boringtun-cli_0.5.2-musl_arm64.deb
boringtun-cli_0.5.2-musl_armhf.deb
boringtun-cli-0.5.2-musl.armv7.rpm
boringtun-cli-0.5.2-musl.x86_64.rpm
```

Credits
-------

* [toolchains.bootlin.com](https://toolchains.bootlin.com/) for embedded toolchains used here to build ARM/musl variants.
