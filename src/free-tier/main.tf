terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {}
}

provider "aws" {
  profile = var.profile
  region  = var.region
  
  default_tags {
    tags = {
      Project     = "terraform-aws-free-tier"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

module "vpc" {
  source = "../modules/vpc"

  environment = var.environment
}

module "public_subnet" {
  source = "../modules/public-subnet"

  vpc_id       = module.vpc.vpc_id
  environment  = var.environment
}

module "internet_gateway" {
  source = "../modules/internet-gateway"

  vpc_id = module.vpc.vpc_id
}

module "route_table" {
  source = "../modules/route-table"

  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.internet_gateway.internet_gateway_id
  public_subnet_id    = module.public_subnet.public_subnet_id
}

module "ec2" {
  source = "../modules/ec2"

  vpc_id                  = module.vpc.vpc_id
  public_subnet_id        = module.public_subnet.public_subnet_id
  environment             = var.environment

  ec2_ssh_key_name        = var.ec2_ssh_key_name
  ec2_ssh_public_key_path = var.ec2_ssh_public_key_path
}
