# ============================== #
# SECURITY MODULE OUTPUTS 
# ============================== #

output "sg_alb_id" {
    description = "ID du groupe de sécurité pour l'ALB"
    value = aws_security_group.sg_alb.id
}

output "sg_ecs_id" {
    description = "ID du groupe de sécurité pour ECS"
    value = aws_security_group.sg_ecs.id
}

output "sg_rds_id" {
    description = "ID du groupe de sécurité pour RDS"
    value = aws_security_group.sg_rds.id
}

output "sg_bastion_id" {
    description = "ID du groupe de sécurité pour Bastion"
    value = aws_security_group.sg_bastion.id
}

output "iam_role_ecs_execution_id" {
    description = "ID du role IAM pour l'exécution des tâches ECS"
    value = aws_iam_role.ecs_task_execution_role.arn
}