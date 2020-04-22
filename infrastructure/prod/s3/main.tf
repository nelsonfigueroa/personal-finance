provider "aws" {
  version = "~> 2.0"
  region  = "us-west-2"
}

module "remote_state" {
  source = "../../modules/s3"
  bucket = "remote-state-prod"
  name   = "remote-state-prod"
}