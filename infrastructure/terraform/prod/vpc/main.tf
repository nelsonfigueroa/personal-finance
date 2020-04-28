terraform {
  backend "s3" {
    bucket = "remote-state-prod"
    key    = "vpc/vpc.tfstate"
    region = "us-west-2"
  }
}

provider "aws" {
  version = "~> 2.0"
  region  = "us-west-2"
}

module "vpc_prod" {
  source     = "../../modules/vpc"
  cidr_block = "10.0.0.0/24"
  name       = "prod"
}