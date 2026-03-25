# ============================================ #
# Variable, paramètre configuratble du module networking
# ============================================ #    

variable "project_name" {
    description = "Nom du projet, utilisé pour taguer les ressources AWS"
    type = string
}

variable "vpc_cidr" {
    description = "Plage d'adresse IP du VPC"
    type = string
    default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
    description = "Plages d'adresses IP de subnets publics"
    type = list(string)
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
    description = "Plages d'adresses IP de subnets privés"
    type = list(string)
    default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
    description = "Zones de disponibilité AWS pour les subnets"
    type = list(string)
    default = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
}