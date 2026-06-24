#!/bin/sh
killall openvpn
echo "nameserver 8.8.8.8" > /etc/resolv.conf