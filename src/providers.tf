terraform {

  required_version = ">=0.12"
  
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.57.0"
    }
  }
  
  backend "azurerm" {
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}