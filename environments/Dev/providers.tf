terraform {
  required_version = ">= 1.1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.0.1"
    }
  }
  backend "azurerm" {
    resource_group_name  = "Dev-RG"
    storage_account_name = "theramy10"
    container_name       = "theramya10"
    key                  = "dev.terraform.tfstate"

  }
}
provider "azurerm" {
  features {}
}