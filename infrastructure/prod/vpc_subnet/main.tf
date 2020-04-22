terraform {
  backend "s3" {
    bucket = "remote-state-prod"
    key    = "vpc_subnet/vpc_subnet.tfstate"
    region = "us-west-2"
  }
}

provider "aws" {
  version = "~> 2.0"
  region  = "us-west-2"
}

data "terraform_remote_state" "vpc" {
  backend = "gcs"
  config = {
    bucket = "remote-state-prod"
    key    = "vpc/vpc.tfstate"
  }
}

module "subnet_prod" {
  source     = "../../modules/vpc_subnet"
  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc.id
  cidr_block = "10.0.0.0/24"
  name       = "prod"
}