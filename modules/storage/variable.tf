# ==============
# STORAGE MODULE VARIABLES
# ==============

variable "project_name" {
  description = "Nom du projet, utilisé pour taguer les ressources AWS"
  type        = string
}

variable "ecr_scan_on_push" {
  description = "Scan Docker Image on push"
  type        = bool
  default     = true
}

variable "ecr_image_max" {
  description = "Maximum number of images to retain in the ECR repository"
  type        = number
  default     = 10
}

variable "ecr_image_tag_prefix" {
  description = "Tag prefix for images to be expired in the ECR repository"
  type        = list(string)
  default     = ["prod", "staging", "dev"]
}

variable "kms_key_description" {
  description = "KMS Key Description"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}
