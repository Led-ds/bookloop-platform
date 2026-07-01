# Preencha com os outputs do bootstrap. Rode: terraform init -reconfigure
terraform {
  backend "s3" {
    bucket         = "REPLACE_state_bucket"
    key            = "environments/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "bookloop-tf-lock"
    encrypt        = true
  }
}
