output "cluster_endpoint" {
  description = "Endpoint de conexión al cluster"
  value       = module.redshift.cluster_endpoint
}

output "security_configuration" {
  description = "Configuración de seguridad"
  value       = module.redshift.security_configuration
  sensitive   = true
}

output "credentials_secret" {
  description = "Detalles del Secrets Manager (si está habilitado)"
  value       = module.redshift.credentials_secret
  sensitive   = true
}