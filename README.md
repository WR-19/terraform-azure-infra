# Terraform Azure Infra

Automated Azure infrastructure deployment using Terraform.  

This repository sets up a Hub-Spoke network topology with Key Vault for secure secrets management and is ready for GitHub Actions CI/CD.

---

## What This Project Does

- Creates a Hub VNet for shared services
- Creates Spoke VNets for applications (Web & API workloads)
- Creates subnets with service endpoints for Key Vault
- Deploys a Key Vault securely into the Web spoke subnet
- Configures VNet peering between hub and spokes
- Provides a dev environment fully ready for testing
- Uses Terraform modules for reusable infrastructure

---

## Repo Structure

- terraform-azure-infra
  - environments
    - dev
      - main.tf
      - variables.tf
      - outputs.tf
    - prod
      - main.tf
      - variables.tf
      - outputs.tf
  - modules
    - hub-network
      - main.tf
      - variables.tf
    - spoke-network
      - main.tf
      - variables.tf
    - security
      - main.tf
      - variables.tf

---

## Prerequisites

- Terraform CLI v1.5+  
- Azure CLI  
- Git  
- Azure subscription (Free Tier works for dev)

---

## Deploy Dev Environment

1. Login to Azure:

```bash
az login
```
2.	Change into the dev environment:
   ```bash
cd environments/dev
```
3. Initialize Terraform:

   ```bash
   terraform init
   ```
5.	Format and validate Terraform files:
   ```bash
terraform fmt -recursive
terraform validate
```
5.	Preview infrastructure changes:
```bash
terraform plan
```
6.	Apply infrastructure:
```bash
terraform apply
```
yes when prompted.

## Terraform Outputs

After deployment, the following outputs are available:
- hub_vnet_id
  
- web_spoke_id
  
- api_spoke_id

- key_vault_uri

  ## Notes / Best Practices
Do not commit .terraform/ directories — they are local-only
Use separate environments (dev/prod) for safety
Keep secrets out of code (*.tfvars are ignored)
Always review Terraform plans before applying to production
