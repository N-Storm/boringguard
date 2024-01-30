Boringguard
===========

A Wireguard VPN install & configuration [Ansible](https://ansible.com) role with [Boringtun](https://github.com/cloudflare/boringtun) userspace implementation.
Boringtun is a userspace Wireguard "server" implementation by [CloudFlare](https://www.cloudflare.com/). It works on various architectures and doesn't require
a kernel module to work. This makes it possible to run it under container-type VPS (OpenVZ/Virtuozzo/LXC/etc) without the possibility to load or use additional
kernel modules. Consequently, you can operate your Wireguard private VPN server even on cheap NAT VPS. However, it has to be TUN/TAP enabled (most providers
have an option to enable it).

This role comes with pre-compiled `boringtun-cli` binaries, packaged in deb and rpm formats. They are unmodified builds from sources as is. They are bundled as
binary packages with the playbook because most (if not all) Linux distros lack them in their repos. And I wasn't able to find them in 3rd party trusted repos either.
It's actually the most significant reason I created this role for my purposes and decided to share it afterward. But if you're skeptical about using my binary builds,
you can build and package your own binaries. Instructions for building those can be found [here](build/README.md).

This role comes with x86_64 and ARM (armv7 hardfloat and aarch64) packages. Thus, it's possible to install on SBCs like Raspberry Pi, Orange Pi, etc., and on
plans like Hetzner ARM VPS, for example.

Supported architectures
-----------------------

- x86_64
- aarch64 (ARM64)
- ARMv7 Hardfloat

Supported target distros
------------------------

- Debian 11, 12 (recommended)
- Ubuntu 20.04, 22.04
- EL (CentOS, RHEL, RockyLinux, AlmaLinux, Oracle Linux) 8, 9

The execution of this playbook has been tested on Debian 11 & 12 as the Ansible host.

Usage
-----

Install `ansible` & `qrencode` packages. Make sure you have the ansible.posix collection installed (`ansible-galaxy collection list`). Debian 11, 12 will have it
installed with the ansible package (you can check this with `ansible-galaxy collection list`).

Place this role under your Ansible directory/roles/boringguard. Create `configs` and `configs/wireguard` directories under the same path where your playbook
is located. This role won't create them itself.
Make your playbook (you can use the included [boringguard.yaml](boringguard.yaml) as an example) and include this role.
You can configure settings by adjusting role variables (see below for description) or by editing the locally saved config in the 'configs' directory later. This
role can also be selected by the tag `boringguard`.

#### Run playbook:

```shell
ansible-playbook [-v] [-i your_inventory_path] [-l target_hosts] [-t boringguard] playbook.yaml
```

After the first successful run, it will save the complete generated host config under the `configs` directory (named `boringguard-cfg-<ansible host>.yaml`)
where it will store all host parameters (generated keys, PSK, and settings). On the next run (if this config file exists), it will apply settings from it (unless
the `wg_override_config` variable is set to true) to make sure things like Wireguard keys won't change on successive runs (so you can adjust settings, like changing
port or adding more peers). So, if you need to change some settings without generating new keys, you must edit this file.

Peer (client) configs will be saved under the `configs/wireguard` directory. Named `<ansible host>-PeerN.conf` and `<ansible host>-qrcode.(txt|png)`. You can use
either of them to add the config to the Wireguard client.

Requirements
------------

- `qrencode` installed on the Ansible host.

Dependencies
------------

- [ansible.posix.sysctl module](https://docs.ansible.com/ansible/latest/collections/ansible/posix/sysctl_module.html)

Role Variables
--------------

These are either set to "weak" defaults or unset. So you can configure them anywhere you like - hostvars, group vars, playbook, etc.
Even in the role vars file, or with the ansible-playbook command-line key `-e`. You can also modify the defaults file, but it's not recommended.

- `wg_host`: hostname of your server (defaults to ansible hostname).
- `wg_port`: listen port (default: 51820).
- `wg_iface`: interface to listen on, must specify one (default: eth0).
- `wg_npeers`: number of peers (clients) to create during initial setup (default: 1).
- `wg_public_ip`: IPv4 address the host can be seen on the Internet. If you are behind NAT, this should still be set to the correct public IP (default: autodiscover).
- `wg_use_public_ip`: use public IP instead of IP configured on interface `wg_iface` for setup (boolean, default: false).
- `wg_override_config`: allow doing the initial install from scratch, overriding existing config (boolean, default: not set).

Example Playbook
----------------

See [boringguard.yaml](boringguard.yaml).

License
-------

Mozilla Public License Version 2.0

Boringtun is licensed under the BSD-3-Clause license. See [LICENSE.boringtun-cli.txt](LICENSE.boringtun-cli.txt) for details.

Inspired by [Nyr wireguard-install script](https://github.com/Nyr/wireguard-install).
