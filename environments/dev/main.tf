# ==============
# PROVIDER 
# ================

terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 6.8"
        }
    }
}

provider "aws" {
    region = "eu-west-3"
}

# ================
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

# ================
# SECURITY
# ================

module "security" {
    source = "../../modules/security"

    project_name = "aws-infra-blueprint"
    vpc_id = module.networking.vpc_id
    allowed_cidr_blocks = ["0.0.0.0/0"]
    bastion_ip = var.bastion_ip
    security_group_ecs_port = var.security_group_ecs_port
    security_group_rds_port = var.security_group_rds_port
}