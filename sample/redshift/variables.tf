variable "client" {
  type        = string
  description = "Nombre del cliente para naming de recursos"
}

variable "project" {
  type        = string
  description = "Nombre del proyecto para naming de recursos"
}

variable "environment" {
  type        = string
  description = "Ambiente (dev/stage/prod)"
}

variable "deployment_type" {
  type        = string
  description = "Tipo de despliegue: 'provisioned' o 'serverless'"

  validation {
    condition     = contains(["provisioned", "serverless"], var.deployment_type)
    error_message = "El tipo de despliegue debe ser 'provisioned' o 'serverless'"
  }
}

variable "common_tags" {
  type        = map(string)
  description = "Tags comunes para todos los recursos"
  default     = {}
}

variable "store_credentials" {
  type        = bool
  description = "Guardar credenciales en AWS Secrets Manager"
  default     = false
}

variable "redshift_config" {
  description = "Configuración completa del cluster Redshift"
  type = object({
    cluster_identifier = string
    
    database = object({
      name              = string
      db_username       = optional(string)
      db_password       = optional(string)
      default_namespace = optional(string)
    })
    
    network = object({
      subnet_ids           = list(string)
      security_group_ids   = list(string)
      enhanced_vpc_routing = optional(bool, true)
      publicly_accessible  = optional(bool, false)
    })
    
    monitoring = optional(object({
      enable_logging  = optional(bool, false)
      logging_bucket  = optional(string)
      logging_prefix  = optional(string, "redshift-logs/")
    }), {})
    
    provisioned_config = optional(object({
      node_type       = string
      cluster_type    = string
      number_of_nodes = optional(number)
      parameter_group = optional(object({
        family = optional(string, "redshift-1.0")
        name   = optional(string)
      }))
    }))
    
    serverless_config = optional(object({
      base_capacity   = number
      namespace_name  = string
      workgroup_name  = string
      max_capacity    = optional(number, 128)
    }))
    
    security = optional(object({
      encrypted        = optional(bool, true)
      kms_key_id       = optional(string)
      iam_roles        = optional(list(string))
      rotation_enabled = optional(bool, false)
    }), {})
    
    tags = optional(map(string), {})
  })
}