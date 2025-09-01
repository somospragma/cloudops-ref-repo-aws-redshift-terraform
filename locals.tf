locals {
  resource_prefix = "${var.client}-${var.project}-${var.environment}"
  
  # Configuración común
  common_tags = merge(
    {
      TerraformManaged = "true"
      Client          = var.client
      Project         = var.project
      Environment     = var.environment
      DeploymentType  = var.deployment_type
    },
    try(var.redshift_config.tags, {})
  )
  
  # Configuración de logging
  logging_enabled = try(
    var.redshift_config.monitoring.enable_logging, 
    false
  ) && try(
    var.redshift_config.monitoring.logging_bucket != null, 
    false
  )
  
  # Determinar si es serverless
  is_serverless = var.deployment_type == "serverless"
}