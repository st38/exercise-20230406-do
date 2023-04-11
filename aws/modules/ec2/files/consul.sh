#!/bin/bash

# Variables
token=$(curl -X PUT -s "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
local_ip=$(curl -s -H "X-aws-ec2-metadata-token: $token" http://169.254.169.254/latest/meta-data/local-ipv4)

# Prerequisites
apt update
apt install -y curl gnupg lsb-release

# HashiCorp GPG key
curl --fail --silent --show-error --location https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor | \
  dd of=/usr/share/keyrings/hashicorp-archive-keyring.gpg

# Repository
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  tee -a /etc/apt/sources.list.d/hashicorp.list

# Update
apt update

# Consul
apt install -y consul

# Config
cat << EOF > /etc/consul.d/consul.hcl
datacenter = "${datacenter}"
data_dir = "/opt/consul"
encrypt = "${consul_key}"
%{ if consul_server ~}
server = true
bootstrap_expect = 1
%{ endif ~}
retry_join = [
  "provider=aws tag_key=consul_id tag_value=${consul_id}"
]
%{ if !consul_server ~}
node_meta {
  env = "${env}"
  stage = "${stage}"
}
%{ endif ~}
EOF

# Services
%{ if !consul_server ~}
cat << EOF > /etc/consul.d/services.hcl
services {
  id = "wireguard"
  name = "wireguard"
  address = "$local_ip"
  port = 51820
  tags = ["${datacenter}", "${env}.${stage}", "wireguard", "vpn"]
}
EOF
%{ endif }

# Permission
chown --recursive consul:consul /etc/consul.d
chmod 640 /etc/consul.d/*.hcl

# Systemd
systemctl enable consul
systemctl start consul
