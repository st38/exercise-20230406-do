# Locals
locals {
  architecture_map = {
    "x86_64" = "amd64"
    "arm64"  = "arm64"
  }

  os_name_map = {
    ubuntu = "ubuntu/images/hvm-ssd/ubuntu-*-22.04-${local.architecture}-server-*"
  }

  os_owner_map = {
    ubuntu = "099720109477"
  }

  architecture = lookup(local.architecture_map, var.instance_architecture)
  os_owner     = lookup(local.os_owner_map, var.os_name)
  os_name      = lookup(local.os_name_map, var.os_name)
}

# AMI
data "aws_ami" "os" {
  most_recent = true
  owners      = [local.os_owner]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = [local.os_name]
  }
}
