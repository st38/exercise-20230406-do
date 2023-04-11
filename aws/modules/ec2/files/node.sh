#!/bin/bash

# Tools
apt install -y net-tools jq

# Hostname
hostnamectl hostname "$(hostname).${suffix}"
