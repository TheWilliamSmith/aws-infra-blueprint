# =================================== #
# STORAGE MODULE : ECR 
# =================================== #

resource "aws_kms_key" "kms_key" {
  description             = var.kms_key_description
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name = "${var.project_name}-kms-key"
  }

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.aws_account_id}:root"

        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow ECS to use the KMS Key for ECR Encryption"
        Effect = "Allow"
        Principal = {
          Service = "ecr.amazonaws.com"
        }
        Action   = "kms:Encrypt"
        Resource = "*"
      }
    ]
  })
}

resource "aws_ecr_repository" "ecr_repo" {
  name = "${var.project_name}-ecr-repo"

  image_scanning_configuration {
    scan_on_push = var.ecr_scan_on_push
  }

  image_tag_mutability = "IMMUTABLE"

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.kms_key.arn
  }

}

resource "aws_ecr_lifecycle_policy" "ecr_repo_policy" {
  repository = aws_ecr_repository.ecr_repo.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire images after reaching max count"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = var.ecr_image_tag_prefix
          countType     = "imageCountMoreThan"
          countNumber   = var.ecr_image_max
        }
        action = {
          type = "expire"
        }
    }]
    }
  )
}

# trunk-ignore(checkov/CKV_AWS_144): Cross-region replication not required for my portfolio
resource "aws_s3_bucket" "s3_logs" {
  bucket = "${var.project_name}-s3-logs"

  tags = {
    Name = "${var.project_name}-s3-logs"
  }
}

resource "aws_s3_bucket_logging" "s3_assets_logging" {
  bucket = aws_s3_bucket.s3_logs.id

  target_bucket = aws_s3_bucket.s3_logs.id
  target_prefix = "logs/"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_logs_encryption" {
  bucket = aws_s3_bucket.s3_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.kms_key.arn
    }
  }
}

resource "aws_s3_bucket_versioning" "s3_logs_versioning" {
  bucket = aws_s3_bucket.s3_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_logs_public_access_block" {
  bucket = aws_s3_bucket.s3_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_notification" "s3_logs_notification" {
  bucket = aws_s3_bucket.s3_logs.id

  eventbridge = true
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_logs_lifecycle" {
  bucket = aws_s3_bucket.s3_logs.id

  rule {
    id     = "logs-expiration"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 90
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

  }
}

# trunk-ignore(checkov/CKV_AWS_144): Cross-region replication not required for my portfolio
resource "aws_s3_bucket" "s3_assets" {
  bucket = "${var.project_name}-s3-assets"

  tags = {
    Name = "${var.project_name}-s3-assets"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_assets_encryption" {
  bucket = aws_s3_bucket.s3_assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.kms_key.arn
    }
  }
}

resource "aws_s3_bucket_versioning" "s3_assets_versioning" {
  bucket = aws_s3_bucket.s3_assets.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_assets_public_access_block" {
  bucket = aws_s3_bucket.s3_assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_notification" "s3_assets_notification" {
  bucket = aws_s3_bucket.s3_assets.id

  eventbridge = true
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_assets_lifecycle" {
  bucket = aws_s3_bucket.s3_assets.id

  rule {
    id     = "logs-expiration"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 90
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

  }
}
