resource "azurerm_resource_group" "main" {
    name     = "drone-azure-function-demo"
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

resource "azurerm_storage_container" "container" {
  name                  = "function-storage"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  storage_account_name  = "${azurerm_storage_account.sa.name}"
  container_access_type = "private"
}

resource "azurerm_storage_blob" "function_blob" {
  name = "app.zip"
  resource_group_name    = "${azurerm_resource_group.main.name}"
  storage_account_name   = "${azurerm_storage_account.sa.name}"
  storage_container_name = "${azurerm_storage_container.container.name}"
  type   = "block"
  source = "../app.zip"
}

data "azurerm_storage_account_sas" "sas" {
  connection_string = "${azurerm_storage_account.sa.primary_connection_string}"
  resource_types {
    service = false
    container = false
    object    = true
  }
  services {
    blob  = true
    queue = false
    table = false
    file = false
  }
  start  = "2019-08-25"
  expiry = "2020-08-25"
  permissions {
    read    = true
    write   = false
    delete  = false
    list    = false
    add     = false
    create  = false
    update  = false
    process = false
  }
}


resource "azurerm_function_app" "test" {
  name                      = "mcshane-drone-functionapp-test"
  location                  = "${azurerm_resource_group.main.location}"
  resource_group_name       = "${azurerm_resource_group.main.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.plan.id}"
  storage_connection_string = "${azurerm_storage_account.sa.primary_connection_string}"
  enabled = true
  https_only = true
  site_config {
      use_32_bit_worker_process = true
  }

  auth_settings {
      enabled = false
  }

  app_settings = {
    HASH            = "${base64sha256(file("../app.zip"))}"
    WEBSITE_USE_ZIP = "https://${azurerm_storage_account.sa.name}.blob.core.windows.net/${azurerm_storage_container.container.name}/${azurerm_storage_blob.function_blob.name}${data.azurerm_storage_account_sas.sas.sas}"
  }
}
