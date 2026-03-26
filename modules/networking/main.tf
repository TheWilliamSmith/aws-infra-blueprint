# ============================================ #
# Networking module : VPC, Subnets, IGW, NAT Gateway, Route Tables
# ============================================ #    

# VPC

resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr

    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "${var.project_name}-vpc"
    }
}

# PUBLIC SUBNETS

resource "aws_subnet" "subnet_public" {
    count = length(var.public_subnet_cidrs)

    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidrs[count.index]   
    availability_zone = var.availability_zones[count.index]

    map_public_ip_on_launch = true

    tags = {
        Name = "${var.project_name}-public-subnet-${count.index + 1}"
        type = "public"
    }
}

# PRIVATE SUBNETS

resource "aws_subnet" "subnet_private" {
    count = length(var.private_subnet_cidrs)

    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index] 

    map_public_ip_on_launch = false

    tags = {
        Name = "${var.project_name}-private-subnet-${count.index + 1}"
        type = "private"
    }
}

# INTERNET GATEWAY

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.project_name}-igw"
    }
}

# ELASTIC ip

resource "aws_eip" "nat_eip" {
    domain = "vpc"

    tags ={
        Name = "${var.project_name}-nat-eip"
    }
}

# NAT GATEWAY

resource "aws_nat_gateway" "nat_gw" {
    allocation_id = aws_eip.nat_eip.id

    subnet_id = aws_subnet.subnet_public[0].id
    
    tags = {
        Name = "${var.project_name}-nat-gw"
    }

    depends_on = [aws_internet_gateway.igw]
}

# ROUTE TABLES PUBLICS

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "${var.project_name}-public-rt"
    }
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.subnet_public)

  subnet_id      = aws_subnet.subnet_public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# ROUTE TABLES PRIVATES

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
    }

  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.subnet_private)

  subnet_id      = aws_subnet.subnet_private[count.index].id
  route_table_id = aws_route_table.private.id
}