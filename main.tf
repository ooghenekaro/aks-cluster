# Create a resource group
resource "azurerm_resource_group" "karo-rg" {
  name     = "my-rg"
  location = "West Europe"
}

# Create acr Container registry
resource "azurerm_container_registry" "acr" {
  name                = "karoacr"
  resource_group_name = azurerm_resource_group.karo-rg.name
  location            = azurerm_resource_group.karo-rg.location
  sku                 = "Standard"
  admin_enabled       = false
 
}

# Create AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "karo-aks"
  location            = azurerm_resource_group.karo-rg.location
  resource_group_name = azurerm_resource_group.karo-rg.name
  dns_prefix          = "karoks1"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_A2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

# Create role assignment for aks acr pull
resource "azurerm_role_assignment" "example" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}
