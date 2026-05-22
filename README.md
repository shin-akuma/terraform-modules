Description
This PR introduces reusable Terraform modules and supporting enhancements for the Purview workload migration.

What changed
Added new Purview modules:
Purview Account module
Purview Managed Private Endpoints module
Added module documentation and test scaffolding for newly created modules.
Enhanced existing shared modules to support the Purview use case:
Diagnostic settings: added explicit diagnostic log category support
Cost budgets: added notification threshold type support (Actual/Forecasted)
Storage account: added minimum TLS version input
Key Vault: added vault URI output
Effect
Enables module-based composition for Purview infrastructure.
Improves compatibility with locked-down environments and Purview diagnostic requirements.
Aligns new modules with repository standards (README + test folder).
Testing Evidence
Validation performed:

Terraform validate passed for the Purview Account module.
Additional validation to run before merge:

Terraform validate for all newly added modules and updated existing modules.
Terraform fmt check across changed module directories.
Deployment/integration test in a non-production subscription.
Pre-Merge Checklist
Before submitting this PR, please ensure you have completed the following:

 My PR title and description are clear and will make sense in the automated release notes
 I have run terraform validate and terraform fmt locally to verify and lint all changed module files
 I have run deployment tests to ensure the module changes are deployable
 I have updated provider versions in provider.tf if required for the module changes to work
 I have checked for duplicate Pull Requests
 My code/branch is up-to-date with the latest changes in main
 If this is a bug fix, I have included Closes #{issue_number} in the PR description (if applicable)
 I have read the contribution guide and followed the guidelines
