# ============================= # 
# Security Module Variables
# ============================= #

variable "vpc_id" {
    description = "ID du VPC où le groupe de sécurité sera crée"
    type = string
}

variable "project_name" {
    description = "Nom du projet, utilisé pour taguer les ressources AWS"
    type = string
}

variable "allowed_cidr_blocks" {
    description = "Liste des plages CIDR autorisées pour les règles de sécurité"
    type = list(string)
    default = ["0.0.0.0/0"]
}

variable "bastion_ip" {
    description = "Adresse IP autorisée à accéder au groupe de sécurité du bastion"
    type = string
}

variable "security_group_ecs_port" {
    description = "Port pour le groupe de sécurité ECS"
    type = number
    default = 80
}

variable "security_group_rds_port" {
    description = "Port pour le groupe de sécurité RDS"
    type = number
    default = 5432
}