Boringguard
=========

A Wireguard VPN install & configuration [Ansible](https://ansible.com) role with [Boringtun](https://github.com/cloudflare/boringtun) userspace implementation.
Boringtun are userspace Wireguard "server" implementation by CloudFlare. It works under various architectures and doesn't requires kernel module to work.
This makes it possible to run it under container type VPS (OpenVZ/Virtuozzo/LXC/etc) without possibility to load or use own kernel modules.
So it is possible to run your Wireguard private VPN server even on cheap NAT VPS.
This role comes with pre-compilled boringtun-cli packages in deb in rpm. Just a plain build from sources, because most distros doesn't have boringtun
in their repositories. But if you don't trust my builds, you can package your own binaries. This role comes with x86_64 and ARM (armv7 hardfloat and aarch64)
packages. So it's possible to install on SBC like Raspberry Pi, Orange Pi, etc and (for example) Hetzner ARM VPS plans.

Supported distros
------------

- Debian 11, 12 (recommended)
- Ubuntu 20.04, 22.04
- EL (CentOS, RHEL, RockyLinux, AlmaLinux, Oracle Linux) 8, 9

Usage
------------

Place this role under your Ansible directory/roles/boringguard. Create configs and configs/wireguard directories under the same path where is your playbook
are located. This role won't create these itself.
Make your playbook (you can use included boringguard.yaml as example) and include this role.
You can configure settings by adjusting role variables (see below for description) or by editing local saved config in 'configs' directory if you've already
run this role on host.

`ansible-playbook -i your_inventory boringguard.yaml`

After first succesful run, it will save generated host config under `configs` directory (named `boringguard-cfg-<ansible host>.yaml`) where it will store
all host parameters (generated keys, psk and settings). On the next run (if this config file exists), it will apply settings from it (unless
`wg_override_config` variable set to true) to make sure things like Wireguard keys won't change on successive runs (so you can adjust settings, like adding
more peers). So if you need to change some settings without generating new keys, you must edit this file.

Peer (client) configs will be saved under configs/wireguard directory. Named `<ansible host>-PeerN.conf` and `<ansible host>-qrcode.(txt|png)`. You can use
any of them to add config to Wireguard client.

Requirements
------------

qrencode package install on Ansible host.

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here. For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

See boringguard.yaml.

License
-------

- Role: Mozilla Public License Version 2.0
- Boringtun: see LICENSE.boringtun-cli.txt
