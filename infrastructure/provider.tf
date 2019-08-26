provider "azurerm" {
    version = "~> 1.33"
}

terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-mgmt"
    storage_account_name = "terraformmgmt"
    container_name       = "tfstate"
    key                  = "functionapp-demo.terraform.tfstate"
  }
}
