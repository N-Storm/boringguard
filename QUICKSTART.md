1. Install ansible, git, qrencode and optional sshpass if you login with password-based authentication (not with the keys):
  `sudo apt install ansible git qrencode sshpass`
2. Prepare directories for ansible role and config storage:
  `mkdir -p ansible/roles ansible/configs/wireguard`
3. Clone git repo into ansible/roles:
  `cd ansible/roles && git clone https://github.com/N-Storm/boringguard/ && cd ..`
4. Copy example playbook for the role (should be in `ansible` directory right now):
  `cp roles/boringguard/boringguard.yaml .`
5. Check & modify vars inside ansible/boringguard.yaml if required. It will work with defaults as is. But you might want to modify defaults. Uncomment `vars: ` section and any of the `wg_port`, `wg_iface` or `wg_npeers` lines you want to modify:
  * wg_port sets WireGuard port. Default: 51820
  * wg_iface sets network interface interface WireGuard will listen on. Default: eth0
  * wg_npeers sets number of WireGuard peers (clients) what will be created during setup. On first run they will be named Peer<N>, you can change names later if required. Default: 2
6. Once done run the playbook on the desired host. User on the target host can be specified on command line (as with ssh). That account should have sudo access (to install package, configure WireGuard, etc). Option `-k` allows to type ssh password, `-K` does the same if sudo asks for the password again, `-v` turn on a bit more verbose output. `-i` usually sets inventory file with the host list, but you can specify host directly from command line, just note that ',' at the end:
  `ansible-playbook -vkK -i host@port, boringguard.yaml`

Now it should connect to the host via ssh and begin installing and configuring WireGuard. On successful run it will store all the things related to WireGuard setup in the `configs/config-<hostname>.yaml` file. This includes secret keys for the WG, so keep this file private. You can edit that file later to modify settings you want (change port, add/rename/remove peers, etc), then just run the playbook once again as noted in step #6 and it will re-configure everything based on this file.
Configs for the WG clients will be located in the `configs/wireguard` directory. Beginning with the [host name]-[peer name] there will be 3 files for each:
* [host name]-[peer name].conf  - are the file-based WireGuard config, which can be imported on the client
* [host name]-[peer name].qrcode.png - are the image with the WireGuard connection QRCode which can be scanned by supported clients.
* [host name]-[peer name].qrcode.txt - same QRCode, but using ANSIUTF8 pseudo-graphics which can be output to the text terminal right away.

If you want to run on multiple hosts in one run, you can prepare Ansible Inventory file by following this guide: https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html
It's pretty simple in ini format, and can be just "one line per host" as well in this form. Once prepared, you can specify this file with `-i` option on step #6 instead of host directly. Per-host variable can be specified in the inventory file as well. SSH use can be specified as Ansible built-in variable `ansible_user`. Port can be specified as `host:port`. Example inventory file:

```
host1.example.com wg_port=12345
host2.example.com:1234 wg_npeers=1 wg_port=3333, wg_iface=venet0
```

More flexible config options can be configured by adding them to initial playbook or inventory file, but these aren't covered here right now.
