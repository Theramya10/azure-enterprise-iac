data "azurerm_subnet" "subnet" {
  for_each             = var.vms
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.resource_group_name
}

data "azurerm_public_ip" "rosie" {
  for_each            = var.vms
  name                = each.value.pip_name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_key_vault" "keyvault" {
  for_each            = var.keyvault
  name                = each.value.name
  resource_group_name = each.value.resource_group_name

}

data "azurerm_key_vault_secret" "username" {
  for_each     = var.vms
  name         = "vm-admin-username"
  key_vault_id = data.azurerm_key_vault.keyvault[each.value.keyvault].id

}

data "azurerm_key_vault_secret" "password" {
  for_each     = var.vms
  name         = "vm-admin-password"
  key_vault_id = data.azurerm_key_vault.keyvault[each.value.keyvault].id

}

data "azurerm_network_interface" "nic" {
  for_each            = var.vms
  name                = each.value.nic_name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_linux_virtual_machine" "myvm" {
  #checkov:skip=CKV_AZURE_1: "Password auth is intentional to demonstrate dynamic Key Vault injection."
  #checkov:skip=CKV_AZURE_149: "Password auth is intentional to demonstrate dynamic Key Vault injection."
  #checkov:skip=CKV_AZURE_178: "SSH keys are bypassed in favor of Key Vault passwords."
  #checkov:skip=CKV_AZURE_50: "VM extensions are permitted in this dev environment."
  for_each                        = var.vms
  name                            = each.value.vms_name
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  size                            = each.value.size
  admin_username                  = data.azurerm_key_vault_secret.username[each.key].value
  admin_password                  = data.azurerm_key_vault_secret.password[each.key].value
  disable_password_authentication = false
  network_interface_ids           = [data.azurerm_network_interface.nic[each.key].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
