# Cloud init
data "cloudinit_config" "this" {
  gzip          = true
  base64_encode = true

  # Node
  part {
    filename     = "01-node.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/files/node.sh", {
      suffix = local.hostname
    })
  }

  # nftables
  dynamic "part" {
    for_each = var.consul_server ? [] : [1]
    content {
      filename     = "02-nftables.sh"
      content_type = "text/x-shellscript"
      content      = templatefile("${path.module}/files/nftables.sh", {})
    }
  }

  # Consul
  part {
    filename     = "03-consul.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/files/consul.sh", {
      consul_id     = var.consul_id,
      consul_key    = var.consul_key,
      consul_server = var.consul_server,
      datacenter    = var.datacenter,
      env           = var.env,
      stage         = var.stage
    })
  }

  # Consul Template
  dynamic "part" {
    for_each = var.consul_server ? [] : [1]
    content {
      filename     = "04-consul-template.sh"
      content_type = "text/x-shellscript"
      content      = file("${path.module}/files/consul-template.sh")
    }
  }

  # Open ports
  dynamic "part" {
    for_each = var.consul_server ? [] : [1]
    content {
      filename     = "open-ports.sh"
      content_type = "text/x-shellscript"
      content      = file("${path.module}/files/open-ports.sh")
    }
  }

  # Consul Template nftables
  dynamic "part" {
    for_each = var.consul_server ? [] : [1]
    content {
      content_type = "text/cloud-config"
      content = yamlencode({
        write_files = [
          {
            encoding    = "b64"
            content     = base64encode(file("${path.module}/files/nftables-${var.env}.tpl"))
            path        = "/opt/consul-template/nftables.tpl"
            owner       = "root:root"
            permissions = "0644"
          },
        ]
      })
    }
  }
}
