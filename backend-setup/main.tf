# ============================================ #
# Ce fichier créer les ressources qui vont stockées le state Terraform du reste de l'infrastructure
# ============================================ #    

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

# Bucket S3

## Bucket S3 - stocke le fichier terraform terraform.tfstate
resource "aws_s3_bucket" "terraform_state" {
    bucket = "aws-infra-blueprint-terraform-state"

    lifecycle {
        prevent_destroy = true
    }
}

## Active le versionning sur le bucket s3, une nouvelle version est créée à chaque modification -> permet de rollback si un apply se déroule mal
resource "aws_s3_bucket_versioning" "terraform_state" {
    bucket = aws_s3_bucket.terraform_state.id

    versioning_configuration {
      status= "Enabled"
    }
}

## Chiffrement du state (AES-256) des infos sensibles
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
    bucket = aws_s3_bucket.terraform_state.id

    rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = "AES256"
        }
    }
}

## Bloque tout accès public du State
resource "aws_s3_bucket_public_access_block" "terraform_state" {
    bucket = aws_s3_bucket.terraform_state.id

    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

# DynamoDB Table
## DynamoDB agit comme un mutex, un seul apply à la fois si deux personnes font un terraform apply en même temps
resource "aws_dynamodb_table" "terraform_locks" {
    name = "aws-infra-blueprint-terraform-locks"
    billing_mode = "PAY_PER_REQUEST"

    hash_key = "LockId"

    attribute {
        name = "LockId"
        type = "S"
    }
}

# Output
## Affiche les informations après un terraform apply
output "s3_bucket_name" {
    value = aws_s3_bucket.terraform_state.bucket
    description = "Le nom du bucket S3 qui stocke le state Terraform"
}

output "dynamodb_table_name" {
    value = aws_dynamodb_table.terraform_locks.name
    description = "Le nom de la table DynamoDB qui gère les locks Terraform"
}