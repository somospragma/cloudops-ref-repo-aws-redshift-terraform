terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  # Uncomment to use a specific profile
  # profile = var.profile
  
  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project
      ManagedBy   = "Terraform"
    }
  }
}

variable "aws_region" {
  description = "AWS region donde se desplegarán los recursos"
  type        = string
  default     = "us-east-1"
}

# variable "profile" {
#   description = "Perfil AWS a utilizar"
#   type        = string
#   default     = "default"
# }