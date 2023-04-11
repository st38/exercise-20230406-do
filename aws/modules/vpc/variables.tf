# Main
variable "name" {
  description = "Resources name."
  type        = string
  default     = "consul"
}

variable "prefix" {
  description = "Resources prefix."
  type        = string
  default     = "demo"
}

# VPC
variable "cidr_block" {
  description = "The IPv4 CIDR block for the VPC."
  type        = string
  default     = "10.10.0.0/16"
}

variable "az_number" {
  description = "Number of availability zones."
  type        = number
  default     = 3
}
