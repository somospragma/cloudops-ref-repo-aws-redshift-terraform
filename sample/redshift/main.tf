###########################################
######### AWS Redshift module #########
###########################################

module "redshift" {
  source = "../../"
  
  # Configuración básica
  client       = var.client
  project      = var.project
  environment  = var.environment
  
  # Tipo de despliegue
  deployment_type = var.deployment_type
  store_credentials = var.store_credentials
  
  # Configuración completa
  redshift_config = var.redshift_config
  
  # Tags comunes
  common_tags = var.common_tags
}
