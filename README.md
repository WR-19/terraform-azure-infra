# Terraform Azure Infra

Automated Azure infrastructure deployment using **Terraform**.  

This repo sets up a **Hub-Spoke network topology** with Key Vault for secure secrets management and is ready for **GitHub Actions CI/CD**.

---

## What This Project Does

- Creates a **Hub VNet** for shared services.
- Creates **Spoke VNets** for applications (Web & API workloads).
- Creates **subnets** with service endpoints for Key Vault.
- Deploys a **Key Vault** securely into the Web spoke subnet.
- Configures **VNet peering** between hub and spokes.
- Provides a **dev environment** fully ready for testing.
- Uses Terraform **modules** for reusable infrastructure.

---

## Repo Structure
terraform-azure-infra/
├── environments/
│   ├── dev/            # Dev environment Terraform configs
│   └── prod/           # (optional) Prod environment
├── modules/
│   ├── hub-network/    # Hub VNet and subnets
│   ├── spoke-network/  # Spoke VNets and subnets
│   └── security/       # Key Vault module
└── .github/
└── workflows/
└── terraform.yml  # GitHub Actions CI/CD
---

## Prerequisites

- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads) v1.5+
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- Git
- Azure subscription (Free Tier works for dev)

---

## Deploy Dev Environment

1. **Login to Azure**
```bash
az login
cd environments/dev
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply

