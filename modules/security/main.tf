# ======================================== #
# SECURITY MODULE : SECURITY GROUPS, IAM ROLES, POLICIES
# ======================================== #

resource "aws_security_group" "sg_alb" {
    name = "${var.project_name}-sg-alb"
    vpc_id = var.vpc_id

    ingress  {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = var.allowed_cidr_blocks
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = var.allowed_cidr_blocks   
    }

    egress {
        from_port = 0 
        to_port = 0
        protocol = "-1"
        cidr_blocks = var.allowed_cidr_blocks
    }

    tags = {
        Name = "${var.project_name}-sg-alb"
    }
}

resource "aws_security_group" "sg_ecs" {
    name = "${var.project_name}-sg-ecs"
    vpc_id = var.vpc_id

    ingress  {
        from_port = var.security_group_ecs_port
        to_port = var.security_group_ecs_port
        protocol = "tcp"
        security_groups = [aws_security_group.sg_alb.id]
    }


    egress {
        from_port = 0 
        to_port = 0
        protocol = "-1"
        cidr_blocks = var.allowed_cidr_blocks
    }

    tags = {
        Name = "${var.project_name}-sg-ecs"
    }
}

resource "aws_security_group" "sg_rds" {
    name = "${var.project_name}-sg-rds"
    vpc_id = var.vpc_id

    ingress {
        from_port = var.security_group_rds_port
        to_port = var.security_group_rds_port
        protocol = "tcp"
        security_groups = [aws_security_group.sg_ecs.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = var.allowed_cidr_blocks
    }

    tags = {
        Name = "${var.project_name}-sg-rds"
    }
}

resource "aws_security_group" "sg_bastion" {
    name = "${var.project_name}-sg-bastion"
    vpc_id = var.vpc_id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.bastion_ip}/32"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = var.allowed_cidr_blocks
    }

    tags = {
        Name = "${var.project_name}-sg-bastion"
    }
}

resource "aws_iam_role" "ecs_task_execution_role" {
    name = "${var.project_name}-ecs-task-execution-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "ecs-tasks.amazonaws.com"
                }
                Action = "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
    role = aws_iam_role.ecs_task_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_cloud_watch_role_policy" {
    role = aws_iam_role.ecs_task_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

