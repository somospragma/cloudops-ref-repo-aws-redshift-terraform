# 1. Recursos para Redshift Provisioned
resource "aws_redshift_subnet_group" "provisioned" {
  count = var.deployment_type == "provisioned" ? 1 : 0

  name       = "${var.client}-${var.project}-${var.environment}-redshift-subnet"
  subnet_ids = var.redshift_config.network.subnet_ids
  tags       = merge(var.common_tags, { Name = "${var.client}-redshift-subnet" })
}

resource "aws_redshift_cluster" "provisioned" {
  count = var.deployment_type == "provisioned" ? 1 : 0

  # Configuración básica
  cluster_identifier = var.redshift_config.cluster_identifier
  database_name      = var.redshift_config.database.name
  master_username    = var.redshift_config.database.db_username
  master_password    = var.redshift_config.database.db_password
  
  # Configuración específica
  node_type       = var.redshift_config.provisioned_config.node_type
  cluster_type    = var.redshift_config.provisioned_config.cluster_type
  number_of_nodes = try(var.redshift_config.provisioned_config.number_of_nodes, null)

  # Configuración de red
  cluster_subnet_group_name = aws_redshift_subnet_group.provisioned[0].name
  vpc_security_group_ids    = var.redshift_config.network.security_group_ids

  # Configuración de seguridad
  encrypted = try(var.redshift_config.security.encrypted, true)

  tags = merge(var.common_tags, {
    Terraform   = "true"
    Deployment  = "provisioned"
  })
}

# 2. Recursos para Redshift Serverless
resource "aws_redshiftserverless_namespace" "serverless" {
  count = var.deployment_type == "serverless" ? 1 : 0

  namespace_name = var.redshift_config.serverless_config.namespace_name
  admin_username = var.redshift_config.database.db_username
  admin_user_password = var.redshift_config.database.db_password
  db_name       = var.redshift_config.database.name

  tags = merge(var.common_tags, {
    Terraform   = "true"
    Deployment  = "serverless"
  })
}

resource "aws_redshiftserverless_workgroup" "serverless" {
  count = var.deployment_type == "serverless" ? 1 : 0

  workgroup_name = var.redshift_config.serverless_config.workgroup_name
  namespace_name = aws_redshiftserverless_namespace.serverless[0].namespace_name
  base_capacity  = var.redshift_config.serverless_config.base_capacity

  subnet_ids = var.redshift_config.network.subnet_ids
  security_group_ids = var.redshift_config.network.security_group_ids
}

# 3. Recursos comunes
resource "aws_secretsmanager_secret" "credentials" {
  count = var.store_credentials ? 1 : 0

  name = "${var.redshift_config.cluster_identifier}-credentials"
  tags = merge(var.common_tags, {
    SecretType = "redshift-credentials"
  })
}

resource "aws_secretsmanager_secret_version" "credentials" {
  count = var.store_credentials ? 1 : 0

  secret_id = aws_secretsmanager_secret.credentials[0].id
  secret_string = jsonencode({
    username = var.redshift_config.database.db_username
    password = var.redshift_config.database.db_password
    host     = var.deployment_type == "provisioned" ? aws_redshift_cluster.provisioned[0].endpoint : aws_redshiftserverless_workgroup.serverless[0].endpoint[0].address
  })
}