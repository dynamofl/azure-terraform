# providers.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }
}

provider "azurerm" {
  subscription_id = "7862df0e-04c1-4bc2-83c7-d708e95b49a1"
  features {}
}
