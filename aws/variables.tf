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

# EC2
variable "os_name" {
  description = "OS name."
  type        = string
  default     = "ubuntu"
}

variable "instance_architecture" {
  description = "Instance architecture."
  type        = string
  default     = "x86_64"
}

variable "instance_type" {
  description = "Instance type."
  type        = string
  default     = "t3a.nano"
}

variable "desired_capacity" {
  description = "Number of Amazon EC2 instances."
  type        = number
  default     = 1
}

# App
variable "consul_server" {
  description = "Set to true to install Consul server."
  type        = bool
  default     = false
}

variable "datacenter" {
  description = "Fleet datacenter."
  type        = string
  default     = "eu-dc1"
}

variable "env" {
  description = "Fleet environment."
  type        = string
  default     = "metrics"
}

variable "stage" {
  description = "Fleet stage."
  type        = string
  default     = "test"
}
