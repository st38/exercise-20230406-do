# SSH Private key output
output "private_key" {
  description = "SSH Private key"
  value       = tls_private_key.this.private_key_pem
  sensitive   = true
}
