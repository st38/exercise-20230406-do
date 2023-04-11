#!/bin/bash

# ufw
ufw disable
apt remove -y ufw

# Install nftables
apt install -y nftables

# Systemd
systemctl enable nftables
systemctl start nftables
