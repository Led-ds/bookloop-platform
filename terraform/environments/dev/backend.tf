# Preencha com os outputs do bootstrap. Rode: terraform init -reconfigure
terraform {
  backend "s3" {
    bucket         = "bookloop-tfstate-ledds-us-east-1"
    key            = "environments/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "bookloop-tf-lock"
    encrypt        = true
  }
}
