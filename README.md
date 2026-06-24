# KVPN Client
A KUAL extension for running an OpenVPN on jailbroken Kindles.

## Requirements
- A jailbroken Kindle with KUAL installed
- A OpenVPN config file
- kterm

## Supported Devices
Tested on Kindle with a FUSE-based filesystem (`fuse.fsp`). Should work on most jailbroken Kindles running a busybox shell. Tested firmware: <!-- add your firmware version here -->

To see if you kindle is supported run this in kterm

```zcat /proc/config.gz | grep CONFIG_TUN```

If the output looks like:
```# CONFIG_TUN is not set```
then, you cannot use KVPN on your Kindle

## Installation

### 1. Copy the extension
Transfer the `kvpn` folder to your Kindle via USB and place it at:
```
/mnt/us/extensions/kvpn/
```

### 2. Get your OpenVPN config
Get you OpenVPN config file and copy it to `/mnt/us/extensions/kvpn/kindle.ovpn`

### 3. Edit `kindle.ovpn`
Add or update these lines in your `kindle.ovpn` file:
```
auth-user-pass /mnt/us/extensions/kvpn/auth.txt

script-security 2
up "/bin/sh /tmp/update-dns.sh"
down "/bin/sh /tmp/update-dns.sh"
```
Remove or comment out any existing `up` / `down` lines referencing `update-resolv-conf`.

### 4. Create your credentials file
Update `/mnt/us/extensions/kvpn/auth.txt` with your OpenVPN credentials:
```
your_openvpn_username
your_openvpn_password
```

Then lock down the file (recommended):
```sh
chmod 600 /mnt/us/extensions/kvpn/auth.txt
```

### 5. Restart KUAL
KVPN Client should now appear in the KUAL menu.

## Usage
Open KUAL and tap **KVPN Client**:
- **Connect VPN** — starts the VPN and updates DNS
- **Disconnect VPN** — kills the VPN and restores default DNS

## How It Works
- OpenVPN runs as a background process using the `tun0` interface
- DNS is managed via a minimal shell script copied to `/tmp` on each connect (required because `/mnt/us` is mounted with `noexec`)
- Credentials are stored locally in `auth.txt` and never transmitted anywhere except to ProtonVPN's servers

## Troubleshooting

**KVPN Client doesn't appear in KUAL**
- Make sure `config.xml` and `menu.json` are directly inside `/mnt/us/extensions/kvpn/`
- Restart KUAL

**VPN connects but no internet**
- Check DNS: `cat /etc/resolv.conf` — should show `nameserver *.*.*.*` while connected
- Try pinging: `ping 1.1.1.1`

**Permission denied errors**
- The `/mnt/us` filesystem is `noexec` — scripts must be run via `/bin/sh` explicitly, which the extension already handles

**auth-user-pass error**
- Double check `auth.txt` exists at the correct path and contains your OpenVPN credentials (not your Proton account password)

## Notes
- The `openvpn` binary included is compiled for ARM. If it doesn't work on your device, you may need to compile or source a compatible binary for your Kindle's architecture.
- `/tmp` is cleared on reboot — the extension handles this automatically by copying `update-dns.sh` to `/tmp` on each connect.

## License
MIT

## Author
ArmadilloMike