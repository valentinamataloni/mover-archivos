# URL principal de la Function App (con https incluido)
output "function_app_url" {
  value       = "https://${azurerm_linux_function_app.function.default_hostname}"
  description = "URL completa (HTTPS) de la Azure Function App"
}

# Connection string del Storage Origen
output "storage_origen_connection_string" {
  value     = azurerm_storage_account.origen.primary_connection_string
  sensitive = true
  description = "Connection string del Storage Account de origen"
}

# Connection string del Storage Destino
output "storage_destino_connection_string" {
  value     = azurerm_storage_account.destino.primary_connection_string
  sensitive = true
  description = "Connection string del Storage Account de destino"
}

# Nombre del Storage Account de origen
output "storage_origen_name" {
  value = azurerm_storage_account.origen.name
}

# Nombre del Storage Account de destino
output "storage_destino_name" {
  value = azurerm_storage_account.destino.name
}
