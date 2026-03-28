variable "bastion_ip" {
    description = "IP Bastion"
    type = string
}

variable "security_group_ecs_port" {
    description = "Port pour le groupe de sécurité ECS"
    type = number
}

variable "security_group_rds_port" {
    description = "Port pour le groupe de sécurité RDS"
    type = number
}