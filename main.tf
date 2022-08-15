terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = ">=2.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "azurerm_resource_group" "sadey2k" {
  name     = "sadey2k"
  location = westus
}

resource "azurerm_kubernetes_cluster" "sadey2k" {
  name                = "sadey2k-aks1"
  location            = azurerm_resource_group.sadey2k.location
  resource_group_name = azurerm_resource_group.sadey2k.name
  dns_prefix          = "sadey2kaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.sadey2k.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.sadey2k.kube_config_raw

  sensitive = true
}