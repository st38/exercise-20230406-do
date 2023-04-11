# VPC outputs
output "subnets" {
  description = "VPC subnets"
  value       = local.subnets
}

output "security_groups" {
  description = "Security groups"
  value       = local.security_groups
}
