terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.1.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.42.0"
     }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.0"
    }

  }
}

provider "azurerm" {
features {}
}

provider "azuredevops" {
  org_service_url = var.ado_org_service_url
  personal_access_token = var.ado_org_pat
  # Authentication through PAT defined with AZDO_PERSONAL_ACCESS_TOKEN 
}

