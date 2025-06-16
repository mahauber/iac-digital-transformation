terraform {
  backend "azurerm" {
    use_azuread_auth     = true                     # Can also be set via `ARM_USE_AZUREAD` environment variable.
    storage_account_name = "saseed"               # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "tfstate-github-demo"    # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "demo-3.terraform.tfstate" # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
}