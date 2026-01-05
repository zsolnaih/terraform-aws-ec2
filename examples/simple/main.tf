terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.26"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"

}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  availability_zone       = data.aws_availability_zones.available.names[0]
  cidr_block              = cidrsubnet("10.0.0.0/16", 4, 2)
}

module "ec2" {
  source = "github.com/zsolnaih/terraform-aws-ec2?ref=v0.1.0"

  instance_type = "t3.micro"
  subnet_id = aws_subnet.public.id
  ssm_managed = true
}
