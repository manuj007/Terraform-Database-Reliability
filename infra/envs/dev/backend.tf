terraform {
  backend "s3" {
    bucket = "devops-assignment-terraform-state"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}