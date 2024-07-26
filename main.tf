
#============ MAIN =============

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # To comment backend block if working on local and terraform state file is locally stored
  backend "s3" {
    bucket = "sctp-ce7-tfstate"
    key    = "terraform-ex-ec2-lcchua.tfstate"
    region = "us-east-1"
  }
}

# Indicate the provider's region
provider "aws" {
  region = var.region
}
