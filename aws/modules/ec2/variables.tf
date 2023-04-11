# Main
variable "name" {
  description = "Resources name."
  type        = string
  default     = null
}

variable "prefix" {
  description = "Resources prefix."
  type        = string
  default     = "demo"
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

variable "subnets" {
  description = "Subnets for instances launch."
  type        = list(string)
}

variable "security_groups" {
  description = "Security groups for instances launch."
  type        = list(string)
}

variable "key_name" {
  description = "The key name to use for the instance."
  type        = string
}

# App
variable "consul_id" {
  description = "Consul cluster ID."
  type        = string
}

variable "consul_key" {
  description = "Consul gossip encryption key."
  type        = string
}

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
