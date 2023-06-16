# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "amzaiscool"
    container_name       = "karocontainer"
    key                  = "prod.terraform.tfstate"
  }

}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
