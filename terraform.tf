terraform {
  backend "s3" {
    
  }
}

provider "aws" {
  region = var.primary_region
}