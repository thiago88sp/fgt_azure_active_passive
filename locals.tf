locals {
  common_tags = {
    Environment = "Production"
    Owner       = "Thiago Pontes"
    Project     = "FortigateProject"
    Source      = "Terraform"
  }

  customer_prefix = var.customer_prefix
}

