terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}


terraform {
  backend "s3" {
    bucket       = "terraform-state-mustafa"
    key          = "terraform.tfstate"
    region       = "eu-north-1"
    use_lockfile = true
  }
}