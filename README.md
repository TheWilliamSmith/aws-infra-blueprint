# aws-production-blueprint

Infrastructure AWS complète, sécurisée et production-ready, entièrement provisionnée avec Terraform.

---

## Prérequis

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) configuré avec les bons credentials
- Un compte AWS actif

---

## Installation

### 1. Installer Terraform
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install terraform
```

Vérifier l'installation :
```bash
terraform --version
```

### 2. Configurer AWS CLI
```bash
aws configure
```

---

## Démarrage
```bash
terraform init
terraform plan
terraform apply
```