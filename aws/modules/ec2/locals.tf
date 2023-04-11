# Locals
locals {
  name     = var.name == null ? "${var.prefix}-${var.env}.${var.stage}" : "${var.prefix}-${var.name}"
  hostname = var.name == null ? "${var.datacenter}.${var.env}.${var.stage}" : "${var.datacenter}.${var.name}"
}
