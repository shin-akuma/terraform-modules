[CmdletBinding()]
param(
    [string]$SubscriptionId,
    [string]$Location = "australiaeast"
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repoRoot = Split-Path -Parent $PSScriptRoot
$accountsModulePath = Join-Path $repoRoot "modules/purview/accounts"
$accountsTestPath = Join-Path $accountsModulePath "test"
$mpeModulePath = Join-Path $repoRoot "modules/purview/managed-private-endpoints"
$mpeTestPath = Join-Path $mpeModulePath "test"

function Invoke-Terraform {
    param(
        [Parameter(Mandatory = $true)][string]$WorkingDirectory,
        [Parameter(Mandatory = $true)][string[]]$Arguments
    )

    Push-Location $WorkingDirectory
    try {
        Write-Host "terraform $($Arguments -join ' ')" -ForegroundColor Cyan
        & terraform @Arguments
        if ($LASTEXITCODE -ne 0) {
            throw "Terraform command failed in ${WorkingDirectory}: terraform $($Arguments -join ' ')"
        }
    }
    finally {
        Pop-Location
    }
}

Write-Host "Validating Purview Terraform modules..." -ForegroundColor Green

Invoke-Terraform -WorkingDirectory $accountsModulePath -Arguments @("fmt", "-check", "-recursive")
Invoke-Terraform -WorkingDirectory $mpeModulePath -Arguments @("fmt", "-check", "-recursive")

Invoke-Terraform -WorkingDirectory $accountsModulePath -Arguments @("init", "-backend=false", "-no-color")
Invoke-Terraform -WorkingDirectory $accountsModulePath -Arguments @("validate", "-no-color")

Invoke-Terraform -WorkingDirectory $mpeModulePath -Arguments @("init", "-backend=false", "-no-color")
Invoke-Terraform -WorkingDirectory $mpeModulePath -Arguments @("validate", "-no-color")

Invoke-Terraform -WorkingDirectory $mpeTestPath -Arguments @("init", "-backend=false", "-no-color")
Invoke-Terraform -WorkingDirectory $mpeTestPath -Arguments @("test", "-no-color")

if (-not $SubscriptionId) {
    try {
        $SubscriptionId = (& az account show --query id -o tsv 2>$null).Trim()
    }
    catch {
        $SubscriptionId = ""
    }
}

if ($SubscriptionId) {
    Invoke-Terraform -WorkingDirectory $accountsTestPath -Arguments @("init", "-backend=false", "-no-color")
    Invoke-Terraform -WorkingDirectory $accountsTestPath -Arguments @("test", "-no-color", "-var", "subscription_id=$SubscriptionId", "-var", "location=$Location")
}
else {
    Write-Warning "Skipping accounts terraform test: no Azure subscription id available. Pass -SubscriptionId or login with Azure CLI."
}

Write-Host "Purview validation completed successfully." -ForegroundColor Green
