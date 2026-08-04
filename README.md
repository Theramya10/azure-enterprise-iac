# azure-enterprise-iac
"Enterprise-grade Infrastructure as Code (IaC) blueprint for Azure. Features modular Terraform architecture, automated CI/CD pipelines, and strict RBAC security."
# 🚀 Azure Enterprise Infrastructure Blueprint

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)

I built this repository to solve a common enterprise challenge: **How do you deploy secure, scalable, multi-tenant cloud environments without copying and pasting Terraform code?**

This project is a production-ready Infrastructure as Code (IaC) framework. It uses a strict modular design, dynamic state management, and secretless authentication to deploy Azure resources safely and predictably.

## 🏗️ Architecture Overview

This blueprint automatically provisions a secure baseline environment in Azure, including:

*   **Networking:** Virtual Networks (VNets), Subnets, and Network Security Groups designed for isolation.
*   **Compute:** Secure Linux Virtual Machines attached to dedicated Network Interface Cards (NICs) and Static Public IPs.
*   **Secret Management:** Azure Key Vaults configured with strict Role-Based Access Control (RBAC). 
*   **Zero-Trust Identity:** Passwords are auto-generated via Terraform, stored directly into Key Vaults (Data Plane), and injected into VMs without ever being printed to the console or stored in plaintext.

## 💡 Why This Framework? (The 1% Standard)

Most Terraform projects work fine on a local machine but break in production. This repository is built for scale:

1.  **True Multi-Tenancy (DRY Principle):** The core `.tf` modules are completely decoupled from client data. To onboard a new environment or client, you simply create a new `client.tfvars` file. Zero code duplication.
2.  **Secretless CI/CD Pipelines:** Hardcoded credentials are a security liability. This project is designed to integrate with GitHub Actions using **OpenID Connect (OIDC)**, granting temporary, scoped access to Azure.
3.  **Dynamic Remote State:** The backend configuration is injected dynamically during pipeline runs, ensuring State File A never accidentally overwrites State File B.
4.  **Automated Code Quality:** The repository is structured to support pre-commit hooks, `tflint` for logical Azure validation, and `tfsec` for continuous security scanning.

## 📂 Repository Structure

```text
.
├── .github/workflows/       # CI/CD pipelines (Plan, Apply, Security Scans)
├── environments/            # Environment-specific configurations
│   └── Dev/
│       ├── main.tf          # Calls the root modules
│       └── variables.tf     # Variable definitions
├── modules/                 # Reusable, version-controlled building blocks
│   ├── azurerm_keyvault/
│   ├── azurerm_nic/
│   ├── azurerm_resource_group/
│   ├── azurerm_subnet/
│   ├── azurerm_vm/
│   └── azurerm_vnet/
├── .gitignore               # Strict ignores (blocks .tfstate and .tfvars)
├── terraform.tfvars.example # Template for required variables
└── README.md
