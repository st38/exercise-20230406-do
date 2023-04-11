#!/bin/bash

# Variables
config_dir="/etc/consul-template.d"
template_dir="/opt/consul-template"
config="$config_dir/consul-template.hcl"
source="$template_dir/nftables.tpl"
destination="${source%.tpl}.conf"
render_log="${source%.tpl}.log"

# Consul Template
apt install -y consul-template

# Directory
mkdir -p $config_dir
mkdir -p $template_dir

# Config
cat << EOF > $config

template {
  source = "$source"
  destination = "$destination"
  error_fatal = true

  backup = true
  exec {
      command = "nft -c -f $destination && nft -f $destination; date >>$render_log"
      timeout = "30s"
  }
}
EOF

# Systemd
cat << EOF > /lib/systemd/system/consul-template.service

[Unit]
Description="HashiCorp Consul Template - Template engine solution"
Documentation=https://github.com/hashicorp/consul-template
Requires=network-online.target
After=network-online.target consul.service
ConditionFileNotEmpty=/etc/consul-template.d/consul-template.hcl

[Service]
User=root
Group=root
ExecStart=/usr/bin/consul-template -config=$config_dir
ExecReload=/bin/kill -HUP \$MAINPID
KillMode=process
KillSignal=SIGINT
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl enable consul-template
systemctl start consul-template
