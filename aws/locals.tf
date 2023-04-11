# Locals
locals {
  subnets         = module.network.subnets
  security_groups = module.network.security_groups
  key_name        = aws_key_pair.this.id
  consul_id       = random_id.id.hex
  consul_key      = random_id.key.b64_std
}

# Key pair
resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "this" {
  key_name   = "${var.prefix}-${var.name}"
  public_key = tls_private_key.this.public_key_openssh
}

# Consul ID
resource "random_id" "id" {
  byte_length = 16
}

# Consul key
resource "random_id" "key" {
  byte_length = 32
}
