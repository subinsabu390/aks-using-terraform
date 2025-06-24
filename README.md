# 🚀 Deploy a Basic AKS Cluster Using Terraform

This repository contains a modular Terraform configuration for provisioning a **basic Azure Kubernetes Service (AKS)** cluster on Microsoft Azure. The setup is divided into clean, reusable modules for better structure and flexibility across environments.

---

## 📦 Modules Overview

### 1. `aks_cluster`
- Provisions:
  - Azure Kubernetes Service (AKS)
  - Azure Container Registry (ACR)
- Attaches Log Analytics Workspace
- Grants image pull access from AKS to ACR

### 2. `create-ip`
- Creates a **static public IP address**
- Intended for use with:
  - Ingress Controller (e.g., NGINX)
  - Kubernetes Ingress resources

### 3. `install-resources`
- Installs Kubernetes resources using the Helm provider:
  - **cert-manager**
  - **NGINX Ingress Controller**

> You can add more modules (e.g., `apply_yaml_files`) for additional resource provisioning, but managing YAML files directly in Terraform may introduce readability issues. Consider using tools like **Ansible** or integrating with a **CI/CD pipeline** for full automation.

---

## 📂 Repository Structure

1. main.tf                                         # Calls and wires all the modules together
2.  backend.tf                                      # Defines remote backend using Azure Blob for state storage & locking
3. dev.tfvars                                      # Example variable file for dev environment
4. variables.tf                                    # Common input variables
5. .gitignore                                      # Excludes .terraform/, *.tfstate, credentials, etc.
6. modules/
  - aks_cluster/                                  # AKS, ACR, Log Analytics provisioning
  - create-ip/                                    # Static IP creation
  - install-resources/                            # Helm-based installations

---

## ⚙️ How to Use

> Make sure you have Terraform and Azure CLI installed and authenticated via `az login`.

### 🔧 Prerequisites

- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- A resource group and storage account (update `backend.tf` accordingly)

### 🧪 Steps to Deploy

# Initialize Terraform and configure backend
terraform init

# Preview the changes for a specific environment
terraform plan -var-file="dev.tfvars"

# Apply the configuration
terraform apply -var-file="dev.tfvars"

> 📌 To deploy to a different environment (e.g., test), create a separate test.tfvars file with appropriate values. Also fill in the subscription id in Line 22 in providers.tf before proceeding with the deployment.