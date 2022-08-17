locals {
  default_tag = {
    Terraform   = "true"
    Environment = var.environment_name
    Team        = "DevOps"
  }
}
