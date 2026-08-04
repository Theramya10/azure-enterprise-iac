rg = {
  rg1 = {
    name     = "dev-rg1"
    location = "centralindia"
  }
}

vnet = {
  vent1 = {
    name                = "dev-vnet"
    resource_group_name = "dev-rg1"
    location            = "centralindia"
    address_space       = ["10.0.0.0/16"]
  }
}

subnet = {
  sn1 = {
    name                 = "dev-subnet"
    virtual_network_name = "dev-vnet"
    resource_group_name  = "dev-rg1"
    address_prefixes     = ["10.0.1.0/24"]
  }
}

pip = {
  pip1 = {
    name                = "dev-ip"
    resource_group_name = "dev-rg1"
    location            = "centralindia"
    allocation_method   = "Static"
  }
  pip2 = {
    name                = "prod-ip"
    resource_group_name = "dev-rg1"
    location            = "centralindia"
    allocation_method   = "Static"
  }
}

nic = {
  pip1 = {
    nic_name                      = "dev-nic"
    location                      = "centralindia"
    resource_group_name           = "dev-rg1"
    subnet_name                   = "dev-subnet"
    vnet_name                     = "dev-vnet"
    private_ip_address_allocation = "Dynamic"


    pip = {
      name = "dev-ipconfig"
    }
  }
}

vm = {
  vm1 = {
    vms_name            = "dev-vm"
    resource_group_name = "dev-rg1"
    location            = "centralindia"
    size                = "Standard_D2s_v3"
    nic_name            = "dev-nic"
    pip_name            = "dev-ip"
    address_allocation  = "Dynamic"
    subnet_name         = "dev-subnet"
    vnet_name           = "dev-vnet"
    keyvault            = "kv1"
  }
}

keyvault = {
  kv1 = {
    name                       = "theramya-kv"
    location                   = "centralindia"
    resource_group_name        = "dev-rg1"
    sku_name                   = "standard"
    purge_protection_enabled   = false
    soft_delete_retention_days = 7
    enable_rbac_authorization  = true
    admin_username             = "theramya10"

  }
}