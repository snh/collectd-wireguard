# collectd-wireguard

A simple shell script which when used with the [_exec_](https://collectd.org/wiki/index.php/Plugin:Exec)
plugin for [_collectd_](https://collectd.org/), will retrieve per-peer [_WireGuard_](https://www.wireguard.com/)
transfer metrics for consumption by _collectd_.

## Example

### WireGuard configuration

```
$ wg
interface: wg0
  public key: 8x0BeYAO6R2v/hKm6kNfohxf9QfQdKd3tfCPsARuemU=
  private key: (hidden)
  listening port: 51820

peer: eynPhbDg/Ca9Z4Nmk37C6TAMwtdsiYIEh1OEzP5z0Es=
  endpoint: 172.28.128.4:51820
  allowed ips: 10.0.0.2/32
  latest handshake: 20 minutes, 45 seconds ago
  transfer: 11.35 GiB received, 57.93 MiB sent

interface: wg1
  public key: 65bI/yi7hwLuuU494nfVSNASkwyIXlYGP7woVzHAq2c=
  private key: (hidden)
  listening port: 51821

peer: z6xFfD7J7oVHWGRO4p3YDyOW2FYuTIZPFjDs4CshaVI=
  allowed ips: 10.0.1.2/32
```

### `collectd-wireguard.sh` output

```
$ COLLECTD_HOSTNAME="example-host" COLLECTD_INTERVAL=5 ./collectd-wireguard.sh
PUTVAL "example-host/wireguard-wg0/if_octets-eynPhbDg/Ca9Z4Nmk37C6TAMwtdsiYIEh1OEzP5z0Es=" interval=5 N:12182053116:60742952
PUTVAL "example-host/wireguard-wg1/if_octets-z6xFfD7J7oVHWGRO4p3YDyOW2FYuTIZPFjDs4CshaVI=" interval=5 N:0:0
```

## Requirements

- [_WireGuard_](https://www.wireguard.com/)
- [_collectd_](https://collectd.org/)
  - [_exec_ plugin](https://collectd.org/wiki/index.php/Plugin:Exec)
- [_Bash_](https://www.gnu.org/software/bash/)
- [_Sudo_](https://www.sudo.ws/)

## Configuration

This example assumes that the script will be run as the `collectd` user, using
`sudo` to run `wg show all transfer` as `root`.

For security reasons, it is not recommended that you run this script directly as
`root`.

To run this script as a different user, replace `collectd` in the _collectd_ and
_sudoers_ with the appropriate username.

These instructions may require some tweaking depending on your specific
environment and/or operating system/distribution.

### _collectd-wireguard_

Place `collectd-wireguard.sh` in a suitable location, accessible by the user
running this script. For this example `/usr/share/collectd/` is used.

### _collectd_

Add the following to your `collectd.conf`, which is often located at
`/etc/collectd/collectd.conf`:

```
LoadPlugin exec

<Plugin exec>
  Exec "collectd" "/usr/share/collectd/collectd-wireguard.sh"
</Plugin>
```

This example executes the script as the `collectd` user.

### _sudoers_

To allow the user running the script to execute `wg show all transfer`, add the
following to your `sudoers` file using `visudo`:

```
collectd ALL=(root) NOPASSWD: /usr/bin/wg show all transfer
```

## Development

A _Vagrant_ `Vagrantfile` is included which will provision two Debian Buster
based nodes with _WireGuard_, _collectd_, and _collectd-wireguard_.

_collectd_ is configured to write to `/var/lib/collectd/csv/` in CSV format.

## License

```
MIT License

Copyright (c) 2019 Steven Honson

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
