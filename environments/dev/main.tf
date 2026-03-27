# ==============
# PROVIDER 
# ================

terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = "eu-west-3"
}

# ==============
# NETWORKING 
# ================

module "networking" {
    source = "../../modules/networking"

    project_name = "aws-infra-blueprint"
    vpc_cidr = "10.0.0.0/16"
    public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
    availability_zones = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
}
