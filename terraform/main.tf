terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

locals {
  tags = { owner = "platform-team", environment = "development", project = "policy-lab" }
}

resource "aws_vpc" "platform" {
  cidr_block = "10.42.0.0/16"
  tags       = merge(local.tags, { Name = "policy-lab-vpc" })
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.platform.id
  cidr_block              = "10.42.10.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = false
  tags                    = merge(local.tags, { Name = "policy-lab-private" })
}
