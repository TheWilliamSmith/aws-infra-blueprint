# ============================================ #
# OUTPUT 
# ============================================ #    

output "vpc_id" {
    description = "VPC ID"
    value = aws_vpc.main.id
}

output "public_subnet_ids" {
    description = "Subnets Publics IDs"
    value = aws_subnet.subnet_public[*].id
}

output "private_subnet_ids" {
    description = "Private Subnets Ids"
    value = aws_subnet.subnet_private[*].id
}