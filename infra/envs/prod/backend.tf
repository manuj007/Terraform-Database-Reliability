terraform {
  backend "s3" {
    bucket = "devops-assignment-terraform-state"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}