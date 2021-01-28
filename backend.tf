 terraform {
    backend "s3" {
    bucket = "usbank-bucket"
    key    = "resources/terraform.tfstate"
    region = "us-east-1"
  }

 }

