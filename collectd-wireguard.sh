#!/bin/bash
#
# MIT License
#
# Copyright (c) 2019 Steven Honson
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

hostname="${COLLECTD_HOSTNAME:-$(hostname)}"
interval="${COLLECTD_INTERVAL:-60}"

[ $UID == 0 ] || sudo="sudo"

while sleep "$interval"; do
  while read -r interface peer transfer_rx transfer_tx; do
    if [ -z "$peer" ]; then
      echo "Error: No peers are configured." >&2
      exit 1
    fi

    echo "PUTVAL \"$hostname/wireguard-$interface/if_octets-$peer\" interval=$interval N:$transfer_rx:$transfer_tx"
  done <<< $($sudo wg show all transfer)
done
