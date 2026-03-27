# =============================
# BUCKET S3
# =============================

terraform {
    backend "s3" {
        bucket = "aws-infra-blueprint-terraform-state"
        key = "dev/terraform.tfstate"
        region = "eu-west-3"
        dynamodb_table = "aws-infra-blueprint-terraform-locks"
        encrypt = true
    }
}

