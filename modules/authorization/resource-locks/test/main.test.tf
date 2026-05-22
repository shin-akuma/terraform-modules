/*======================================================================
TEST: Locks Module with Storage Account and Private Endpoint
======================================================================
This test demonstrates the locks module pattern by:
1. Creating a storage account WITHOUT inline locks (resource_lock_level = "None")
2. Deploying complex networking (VNet, subnet, private endpoint, DNS)
3. Applying locks as the FINAL step using the locks module

Expected Outcome:
- Deploy: All resources created successfully, lock applied last
- Destroy: Lock removed first, then all resources destroyed cleanly
======================================================================*/

terraform {
  required_version = ">= 1.9.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0, < 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
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

/*======================================================================
RANDOM NAMING
======================================================================*/
resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

locals {
  location      = "australiaeast"
  random_suffix = random_string.random.result
  base_name     = "arnlock${local.random_suffix}"
}

/*======================================================================
RESOURCE GROUP
======================================================================*/
resource "azurerm_resource_group" "test" {
  name     = "rg-${local.base_name}"
  location = local.location
}

/*======================================================================
NETWORKING - VNet, Subnet, Private DNS Zone
======================================================================*/
resource "azurerm_virtual_network" "test" {
  name                = local.base_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = "private-endpoints"
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.test.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  name                  = "${local.base_name}-blob"
  resource_group_name   = azurerm_resource_group.test.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = azurerm_virtual_network.test.id
}

/*======================================================================
STORAGE ACCOUNT - WITHOUT INLINE LOCKS
======================================================================*/
module "storage_account" {
  source = "../../../storage/storage-account"

  name                = local.base_name
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  sku                 = "Standard_LRS"

  # CRITICAL: Disable inline locks
  resource_lock_level = "None"

  # Network security
  network_rules = [
    {
      default_action             = "Deny"
      bypass                     = ["AzureServices"]
      ip_rules                   = []
      virtual_network_subnet_ids = [azurerm_subnet.private_endpoints.id]
    }
  ]

  public_network_access_enabled = false
}

/*======================================================================
PRIVATE ENDPOINT
======================================================================*/
resource "azurerm_private_endpoint" "storage" {
  name                = "${local.base_name}-pe"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  subnet_id           = azurerm_subnet.private_endpoints.id

  private_service_connection {
    name                           = "${local.base_name}-psc"
    private_connection_resource_id = module.storage_account.resource_id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "storage-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob.id]
  }
}

/*======================================================================
RESOURCE LOCKS - Applied as FINAL step
======================================================================*/
module "locks" {
  source = "../"

  locks = {
    storage_account = {
      resource_name = module.storage_account.name
      resource_id   = module.storage_account.resource_id
      kind          = "CanNotDelete"
    }
  }

  depends_on = [
    module.storage_account,
    azurerm_private_endpoint.storage,
    azurerm_private_dns_zone_virtual_network_link.blob
  ]
}

/*======================================================================
OUTPUTS
======================================================================*/
output "test_description" {
  value = <<-EOT
    LOCKS MODULE TEST - SUCCESSFUL PATTERN

    This test demonstrates the correct pattern for resource locks:
    
    Infrastructure Created:
    - Virtual Network: ${azurerm_virtual_network.test.name}
    - Subnet with service endpoints: ${azurerm_subnet.private_endpoints.name}
    - Private DNS Zone: ${azurerm_private_dns_zone.blob.name}
    - Storage Account: ${module.storage_account.name}
    - Private Endpoint: ${azurerm_private_endpoint.storage.name}
    - Resource Lock: ${module.storage_account.name}-lck (CanNotDelete)

    Key Benefits:
    1. Storage account deployed WITHOUT inline lock (resource_lock_level = "None")
    2. Lock applied as FINAL step via locks module
    3. Explicit depends_on ensures proper ordering

    Deployment Sequence:
    1. VNet → Subnet → Private DNS Zone → Storage Account → Private Endpoint
    2. Lock applied LAST ✓

    Destroy Sequence:
    1. Lock removed FIRST ✓
    2. Private Endpoint → Storage Account → DNS Zone → Subnet → VNet → Resource Group

    Test Commands:
    # Deploy with locks
    terraform init
    terraform plan
    terraform apply -auto-approve

    # Verify lock exists
    az lock list --resource-group ${azurerm_resource_group.test.name}

    # Clean destroy (locks removed first automatically)
    terraform destroy -auto-approve

    Result: All resources destroyed successfully without manual intervention!
  EOT
}

output "storage_account_id" {
  value = module.storage_account.resource_id
}

output "lock_ids" {
  value = module.locks.lock_ids
}

output "lock_names" {
  value = module.locks.lock_names
}
