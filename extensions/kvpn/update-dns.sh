#!/bin/sh
if [ "$script_type" = "up" ]; then
    echo "nameserver 10.2.0.1" > /etc/resolv.conf
fi
if [ "$script_type" = "down" ]; then
    echo "nameserver 8.8.8.8" > /etc/resolv.conf
fi