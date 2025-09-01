output "cluster_endpoint" {
  description = "Endpoint de conexión al cluster"
  value = var.deployment_type == "provisioned" ? {
    address = aws_redshift_cluster.provisioned[0].endpoint
    port    = aws_redshift_cluster.provisioned[0].port
  } : {
    address = aws_redshiftserverless_workgroup.serverless[0].endpoint[0].address
    port    = 5439
  }
}

output "security_configuration" {
  description = "Configuración de seguridad"
  value = {
    encrypted = try(var.redshift_config.security.encrypted, true)
  }
  sensitive = true
}

output "credentials_secret" {
  description = "Detalles del Secrets Manager (si está habilitado)"
  value = var.store_credentials ? {
    arn  = aws_secretsmanager_secret.credentials[0].arn
    name = aws_secretsmanager_secret.credentials[0].name
  } : null
  sensitive = true
}