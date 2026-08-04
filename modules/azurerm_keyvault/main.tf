data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {

  for_each = var.az_kv

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name  = each.value.sku_name

  purge_protection_enabled   = each.value.purge_protection_enabled
  soft_delete_retention_days = each.value.soft_delete_retention_days

  rbac_authorization_enabled = each.value.enable_rbac_authorization
}

resource "azurerm_role_assignment" "kv_secrets_officer" {

  for_each = var.az_kv

  scope                = azurerm_key_vault.kv[each.key].id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "random_password" "vm_password" {

  for_each = var.az_kv

  length           = 20
  special          = true
  override_special = "!@#$%^&*"
}

resource "azurerm_key_vault_secret" "vm_username" {

  for_each = var.az_kv

  depends_on = [azurerm_role_assignment.kv_secrets_officer]

  name         = "vm-admin-username"
  value        = each.value.admin_username
  key_vault_id = azurerm_key_vault.kv[each.key].id
}

resource "azurerm_key_vault_secret" "vm_password" {

  for_each = var.az_kv

  depends_on = [azurerm_role_assignment.kv_secrets_officer]

  name         = "vm-admin-password"
  value        = random_password.vm_password[each.key].result
  key_vault_id = azurerm_key_vault.kv[each.key].id
}