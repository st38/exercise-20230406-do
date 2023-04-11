# Locals
locals {
  name            = "${var.prefix}-${var.name}"
  az_names        = data.aws_availability_zones.this.names
  az_list         = [for az in slice(local.az_names, 0, local.az_number) : az]
  az_number       = local.az_available < var.az_number ? local.az_available : var.az_number
  az_available    = length(local.az_names)
  subnets         = [for subnet in aws_subnet.this : subnet.id]
  security_groups = split(" ", aws_security_group.this.id)
}

# AZ
data "aws_availability_zones" "this" {
  state = "available"
}
