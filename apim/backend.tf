terraform {
  required_version = "~> 0.14.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.95.0"
    }
  }

  backend "azurerm" {
  }
}

provider "azurerm" {
  features {}
}
