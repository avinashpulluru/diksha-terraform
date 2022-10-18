terraform {
  backend "azurerm" {
  resource_group_name  = "storage-rg"
  storage_account_name = "pocdikshatfstate"
  container_name       = "tfstate"
  key                  = "aks/terraform.tfstate"
  }
}