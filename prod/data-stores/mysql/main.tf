provider "aws" {
  region = "eu-central-1"
}

module "database" {
  source = "../../../modules/data-stores/mysql"

  db_identifier_prefix = "vklovan-terraform-prod-"
  db_name = "ProdTerraformExample"
  db_username = var.db_username
  db_password = var.db_password
}

terraform {
  backend "s3" {
    bucket = "vklovan-terraform-up-and-running-state"
    key = "prod/data-stores/mysql/terraform.tfstate"
    region = "eu-central-1"
    dynamodb_table = "vklovan-terraform-up-and-running-locks"
    encrypt = true
  }
}
