terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.9.0"
    }
  }
}

variable "IMAGEBUILD" {
  type            = string
  description     = "Latest Image Build" 
}


# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Configure Terraform to use state file
terraform {
  backend "azurerm" {
    resource_group_name   = "tf_rg_blobstorage"
    storage_account_name  = "tfstorageawf"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}



# Create a resource group
resource "azurerm_resource_group" "terraform_testing" {
  name     = "terraform_testing"
  location = "South East Asia"
}

resource "azurerm_container_group" "terraform_container_testing" {
  name                = "weatherapi"
  location            = azurerm_resource_group.terraform_testing.location
  resource_group_name = azurerm_resource_group.terraform_testing.name

  ip_address_type       = "Public"
  dns_name_label        = "awfweatherapi"
  os_type               = "Linux"

  container {
    name                = "weatherapi"
    image               = "andyfeetenby/weatherapi:${var.IMAGEBUILD}"
    cpu                 = "1"
    memory              = "1"

    ports {
      port              = 80
      protocol          = "TCP" 
    } 
  } 
}