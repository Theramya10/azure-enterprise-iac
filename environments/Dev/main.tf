module "resource_group" {
  source = "../../modules/azurerm_resource_group"
  rg     = var.rg
}
module "virtual_network" {
  depends_on = [module.resource_group]
  source     = "../../modules/azurerm_vnet"
  vnet       = var.vnet
}
module "subnet" {
  depends_on = [module.virtual_network]
  source     = "../../modules/azurerm_subnet"
  subnet     = var.subnet
}

module "pip" {
  depends_on = [module.subnet]
  source     = "../../modules/azurerm_nic"
  pip        = var.pip
  nic        = var.nic
}
module "azurerm_linux_virtual_machine" {
  depends_on = [module.subnet, module.pip, module.keyvault]
  source     = "../../modules/azurerm_vm"
  vms        = var.vm
  keyvault   = var.keyvault
}

module "keyvault" {
  depends_on = [module.resource_group]
  source     = "../../modules/azurerm_keyvault"
  az_kv      = var.keyvault

}