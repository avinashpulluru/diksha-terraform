provider "azurerm" {
  skip_provider_registration = true
  features { }
}

resource "azurerm_resource_group" "aks-rg" {
  name     = var.resource_group_name
  location = var.location
  }

resource "azurerm_virtual_network" "vvnet" {
  name                = "vnet-01"
  location            = azurerm_resource_group.aks-rg.location
  resource_group_name = azurerm_resource_group.aks-rg.name
  address_space       = ["10.2.0.0/16"]
  
}

resource "azurerm_subnet" "internal1" {
  name                 = "internal"
  virtual_network_name = azurerm_virtual_network.vvnet.name
  resource_group_name  = azurerm_resource_group.aks-rg.name
  address_prefixes     = ["10.2.0.0/20"]
}

/*resource "azurerm_route_table" "aksrt" {
  name                          = "example-route-table"
  location                      = azurerm_resource_group.aks-rg.location
  resource_group_name           = azurerm_resource_group.aks-rg.name
  disable_bgp_route_propagation = false

  route {
    name           = "route1"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "192.168.1.4"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet_route_table_association" "aksrt" {
    subnet_id      = azurerm_subnet.internal1.id
    route_table_id = azurerm_route_table.aksrt.id
}*/

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.aks-rg.name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "diksha-poc"
  location            = azurerm_resource_group.aks-rg.location
  resource_group_name = azurerm_resource_group.aks-rg.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name                = "system"
    node_count          = var.system_node_count
    vm_size             = "Standard_D2s_v3"
    type                = "VirtualMachineScaleSets"
    vnet_subnet_id      = azurerm_subnet.internal1.id
    enable_auto_scaling = false
  }
  
 network_profile {
        network_plugin     = "azure"
        dns_service_ip     = "172.16.1.10"
        service_cidr       = "172.16.0.0/16"
        docker_bridge_cidr = "172.17.0.1/16"
        load_balancer_sku  = "standard"
  }
  identity {
    type = "SystemAssigned"
  }
}
