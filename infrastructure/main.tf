resource "azurerm_resource_group" "main" {
    name     = "${var.rg_name}"
    location = "centralus"
}

resource "azurerm_app_service_plan" "plan" {
  name                = "CentralUSPlan"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  kind                = "functionapp"
  reserved            = false

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_storage_account" "sa" {
  name                     = "functionappmcshanedemo1"
  resource_group_name      = "${azurerm_resource_group.main.name}"
  location                 = "${azurerm_resource_group.main.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource "azurerm_function_app" "test" {
  name                      = "${var.functionapp_name}"
  location                  = "${azurerm_resource_group.main.location}"
  resource_group_name       = "${azurerm_resource_group.main.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.plan.id}"
  storage_connection_string = "${azurerm_storage_account.sa.primary_connection_string}"
  enabled = true
  https_only = true
  version = "~2"
  site_config {
      use_32_bit_worker_process = true
  }

  auth_settings {
      enabled = false
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME      = "node"
    WEBSITE_NODE_DEFAULT_VERSION  = "10.14.1"
  }
}
