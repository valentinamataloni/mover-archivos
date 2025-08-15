terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "4dc63939-80f6-4f50-bd19-bc605cf2786d"
}

# Sufijo aleatorio para nombres únicos
resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}

# 1 - Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-vmataloni"
  location = "eastus2"
}

# 2 - Storage Account Origen
resource "azurerm_storage_account" "origen" {
  name                     = "stororig${random_integer.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# 3 - Storage Account Destino
resource "azurerm_storage_account" "destino" {
  name                     = "stordest${random_integer.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# 4 - Contenedor Origen
resource "azurerm_storage_container" "origen" {
  name                  = "origen"
  storage_account_name  = azurerm_storage_account.origen.name
  container_access_type = "private"
}

# 5 - Contenedor Destino
resource "azurerm_storage_container" "destino" {
  name                  = "destino"
  storage_account_name  = azurerm_storage_account.destino.name
  container_access_type = "private"
}

# 6 - App Service Plan (Consumption para Functions)
resource "azurerm_service_plan" "plan" {
  name                = "plan-functions"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "Y1"
}

# 7 - Azure Linux Function App
resource "azurerm_linux_function_app" "function" {
  name                       = "func-mover-archivos"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  service_plan_id            = azurerm_service_plan.plan.id
  storage_account_name       = azurerm_storage_account.origen.name
  storage_account_access_key = azurerm_storage_account.origen.primary_access_key

  site_config {
    application_stack {
      node_version = "18"
    }
  }

  app_settings = {
    # Conexión para el Blob Trigger
    "AzureWebJobsStorage"          = azurerm_storage_account.origen.primary_connection_string

    # Datos para copiar a destino
    "DEST_STORAGE_ACCOUNT"         = azurerm_storage_account.destino.name
    "DEST_ACCESS_KEY"               = azurerm_storage_account.destino.primary_access_key

    # Config estándar de Azure Functions
    "FUNCTIONS_EXTENSION_VERSION"   = "~4"
    "FUNCTIONS_WORKER_RUNTIME"      = "node"
  }
}
