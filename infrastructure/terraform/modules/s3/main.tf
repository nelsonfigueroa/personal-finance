terraform {
  required_version = ">= 0.12, < 0.13"
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket
  acl    = var.acl

  tags = {
    Name = var.name
  }
}