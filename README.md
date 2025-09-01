# **Módulo Terraform: AWS Redshift**

## Descripción:

Este módulo facilita la creación y gestión de recursos de Amazon Redshift en AWS, soportando tanto despliegues de tipo "provisioned" (clúster tradicional) como "serverless" (sin servidor). Permite configurar todos los aspectos necesarios para implementar una solución de data warehouse en AWS.

Consulta CHANGELOG.md para la lista de cambios de cada versión. *Recomendamos encarecidamente que en tu código fijes la versión exacta que estás utilizando para que tu infraestructura permanezca estable y actualices las versiones de manera sistemática para evitar sorpresas.*

## Estructura del Módulo

El módulo cuenta con la siguiente estructura:

```bash
redshift/
├── locals.tf
├── main.tf
├── outputs.tf
├── variables.tf
├── README.md
├── CHANGELOG.md
└── sample/
    └── redshift/
        ├── main.tf
        ├── outputs.tf
        ├── providers.tf
        ├── terraform.tfvars.sample
        └── variables.tf
```

- Los archivos principales del módulo (`main.tf`, `outputs.tf`, `variables.tf`, `locals.tf`) se encuentran en el directorio raíz.
- `CHANGELOG.md` y `README.md` también están en el directorio raíz para fácil acceso.
- La carpeta `sample/` contiene un ejemplo de implementación del módulo.

## Características Principales

- **Soporte para múltiples tipos de despliegue**: Permite crear tanto clústeres Redshift tradicionales (provisioned) como implementaciones sin servidor (serverless).
- **Configuración flexible**: Estructura modular que permite personalizar todos los aspectos del clúster.
- **Gestión de credenciales**: Opción para almacenar credenciales en AWS Secrets Manager.
- **Configuración de red**: Soporte para configuración de subredes, grupos de seguridad y enrutamiento VPC mejorado.
- **Monitoreo**: Configuración de logging para auditoría y seguimiento.

## Uso del Módulo:

### Ejemplo de Redshift Serverless

```hcl
module "redshift" {
  source = "path/to/module"
  
  # Configuración básica
  client       = "pragma"
  project      = "datalake"
  environment  = "dev"
  
  # Tipo de despliegue
  deployment_type = "serverless"
  store_credentials = false
  
  # Configuración completa
  redshift_config = {
    cluster_identifier = "pragma-dev-redshift-serverless"
    
    serverless_config = {
      base_capacity   = 16
      namespace_name  = "pragma-dev-ns"
      workgroup_name  = "pragma-dev-wg"
    }
    
    database = {
      name              = "datalake_dev"
      db_username       = "admin_serverless"
      db_password       = "YourSecurePassword"
      default_namespace = "public"
    }

    network = {
      subnet_ids           = ["subnet-12345", "subnet-67890"]
      security_group_ids   = ["sg-12345"]
      enhanced_vpc_routing = true
      publicly_accessible  = false
    }

    monitoring = {
      enable_logging  = true
      logging_bucket  = "redshift-logs-pragma-dev"
      logging_prefix  = "serverless-logs/"
    }

    security = {
      encrypted         = true
      kms_key_id        = "alias/aws/redshift"
      rotation_enabled  = false
    }
    
    tags = {
      DataClassification = "confidential"
      DeploymentType     = "serverless"
    }
  }
  
  # Tags comunes
  common_tags = {
    Area        = "analytics"
    Owner       = "data_team"
    CostCenter  = "CC-1234"
    ManagedBy   = "Terraform"
  }
}
```

### Ejemplo de Redshift Provisioned

```hcl
module "redshift" {
  source = "path/to/module"
  
  # Configuración básica
  client       = "pragma"
  project      = "datalake"
  environment  = "dev"
  
  # Tipo de despliegue
  deployment_type = "provisioned"
  store_credentials = true
  
  # Configuración completa
  redshift_config = {
    cluster_identifier = "pragma-dev-redshift-provisioned"
    
    provisioned_config = {
      node_type       = "ra3.xlplus"
      cluster_type    = "multi-node"
      number_of_nodes = 2
    }
    
    database = {
      name        = "datalake_dev"
      db_username = "admin_provisioned"
      db_password = "YourSecurePassword"
    }

    network = {
      subnet_ids           = ["subnet-12345", "subnet-67890"]
      security_group_ids   = ["sg-12345"]
      enhanced_vpc_routing = true
      publicly_accessible  = false
    }

    monitoring = {
      enable_logging  = true
      logging_bucket  = "redshift-logs-pragma-dev"
      logging_prefix  = "provisioned-logs/"
    }

    security = {
      encrypted         = true
      rotation_enabled  = true
    }
    
    tags = {
      DataClassification = "confidential"
      DeploymentMode     = "provisioned"
    }
  }
  
  # Tags comunes
  common_tags = {
    Area        = "analytics"
    Owner       = "data_team"
    CostCenter  = "CC-1234"
    ManagedBy   = "Terraform"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_redshift_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_cluster) | resource |
| [aws_redshift_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_subnet_group) | resource |
| [aws_redshiftserverless_namespace](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshiftserverless_namespace) | resource |
| [aws_redshiftserverless_workgroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshiftserverless_workgroup) | resource |
| [aws_secretsmanager_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="client"></a> [client](#input\_client) | Nombre del cliente para naming de recursos | `string` | `null` | no |
| <a name="project"></a> [project](#input\_project) | Nombre del proyecto para naming de recursos | `string` | `null` | no |
| <a name="environment"></a> [environment](#input\_environment) | Ambiente (dev/stage/prod) | `string` | `null` | no |
| <a name="deployment_type"></a> [deployment_type](#input\_deployment_type) | Tipo de despliegue: 'provisioned' o 'serverless' | `string` | n/a | yes |
| <a name="common_tags"></a> [common_tags](#input\_common_tags) | Tags comunes para todos los recursos | `map(string)` | `{}` | no |
| <a name="store_credentials"></a> [store_credentials](#input\_store_credentials) | Guardar credenciales en AWS Secrets Manager | `bool` | `false` | no |
| <a name="redshift_config"></a> [redshift_config](#input\_redshift_config) | Configuración completa del cluster Redshift | `object` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="cluster_endpoint"></a> [cluster_endpoint](#output\_cluster_endpoint) | Endpoint de conexión al cluster |
| <a name="security_configuration"></a> [security_configuration](#output\_security_configuration) | Configuración de seguridad |
| <a name="credentials_secret"></a> [credentials_secret](#output\_credentials_secret) | Detalles del Secrets Manager (si está habilitado) |