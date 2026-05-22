# Azure Resource Locks Module

This module manages Azure resource locks independently from the resources they protect. It is designed to be called as a final step in Terraform deployments to ensure locks are created last and removed first during destroy operations.

## Purpose

Azure resource locks prevent accidental deletion or modification of critical resources. However, when locks are created inline within resource modules, they can cause Terraform destroy operations to fail, especially in complex infrastructures with private endpoints and networking dependencies.

This standalone locks module addresses this problem by:
- Creating locks as a separate, final deployment step
- Ensuring locks are removed first during destroy operations
- Supporting multiple resources with different lock types in a single call
- Providing flexibility to disable locks during testing without modifying module parameters

## Usage

### Basic Example

```hcl
module "locks" {
  source = "../../modules/authorization/resource-locks"

  locks = {
    storage_production = {
      resource_name = module.storage_account.name
      resource_id   = module.storage_account.resource_id
      kind          = "CanNotDelete"
    }
  }

  depends_on = [
    module.storage_account,
    azurerm_private_endpoint.storage
  ]
}
```

### Multiple Resources with Different Lock Types

```hcl
module "locks" {
  source = "../../modules/authorization/resource-locks"

  locks = {
    cognitive_services_prod = {
      resource_name = module.cognitive_services.name
      resource_id   = module.cognitive_services.resource_id
      kind          = "CanNotDelete"
    }
    storage_audit_logs = {
      resource_name = module.storage_audit.name
      resource_id   = module.storage_audit.resource_id
      kind          = "ReadOnly"
    }
    key_vault_secrets = {
      resource_name = module.key_vault.name
      resource_id   = module.key_vault.resource_id
      kind          = "CanNotDelete"
    }
  }

  depends_on = [
    module.cognitive_services,
    module.storage_audit,
    module.key_vault,
    azurerm_private_endpoint.cognitive_services,
    azurerm_private_endpoint.storage,
    azurerm_private_endpoint.key_vault
  ]
}
```

### Disabling Locks for Testing

```hcl
# Comment out the entire module block to deploy without locks
# module "locks" {
#   source = "../../modules/authorization/resource-locks"
#   locks  = { ... }
# }
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| locks | Map of locks to create. Key is a unique identifier, value contains lock configuration. | `map(object({ resource_name = string, resource_id = string, kind = string }))` | `{}` | no |

### Lock Configuration Object

- `resource_name` (string): Name of the resource being locked (used in lock naming: `{resource_name}-lck`)
- `resource_id` (string): Full Azure resource ID to apply the lock to
- `kind` (string): Lock type - either `"CanNotDelete"` or `"ReadOnly"`

## Outputs

| Name | Description |
|------|-------------|
| lock_ids | Map of lock IDs keyed by the input lock key |
| lock_names | Map of lock names keyed by the input lock key |

## Lock Types

### CanNotDelete
Users can read and modify a resource, but cannot delete it. This is the most common lock type for production resources.

### ReadOnly
Users can read a resource, but cannot delete or update it. Applying this lock is similar to restricting all authorized users to the permissions granted by the Reader role.

## Important Considerations

### Dependency Management

Always use `depends_on` to ensure locks are created after all dependent infrastructure:

```hcl
module "locks" {
  source = "../../modules/locks"
  
  locks = { ... }

  depends_on = [
    module.resource1,
    module.resource2,
    azurerm_private_endpoint.example
  ]
}
```

This ensures:
- Locks are created as the **final step** during apply
- Locks are destroyed **first** during destroy

### Lock Naming Convention

Locks are automatically named using the pattern: `{resource_name}-lck`

Example: If `resource_name = "arnprobst01"`, the lock will be named `arnprobst01-lck`

### Migration from Inline Locks

When migrating existing modules that use inline locks:

1. Set `resource_lock_level = "None"` in the module call
2. Add the locks module with explicit `depends_on`
3. Test the deployment and destroy workflow

### Removing Locks Manually

If you need to manually remove locks (e.g., for emergency cleanup):

```bash
# List locks in a resource group
az lock list --resource-group <resource-group-name> --query "[].{Name:name, Id:id}" -o table

# Delete a specific lock
az lock delete --name <lock-name> \
  --resource-group <resource-group-name> \
  --resource-type <resource-type> \
  --resource <resource-name>
```

## Terraform Compatibility

- Terraform >= 1.9.0
- AzureRM Provider >= 4.0

## License

Copyright (c) Arinco. All rights reserved.
