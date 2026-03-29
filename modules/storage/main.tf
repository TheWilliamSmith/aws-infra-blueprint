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
