terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.84.0"
    }
  }
}

provider "azurerm" {
    #subscription_id = var.SUBSCRIPTION_ID
    #client_id = var.SP_CLIENT_ID
    #client_secret = var.SP_CLIENT_SECRET
    #tenant_id = var.SP_TENANT_ID
    #version = "2.5.0"
    features {}
}

terraform {
  backend "azurerm" {
      resource_group_name   = "tf_rg_blobstore"
      storage_account_name  = "tfstoragenigerninja"
      container_name        = "tfstate"
      key                   = "terraform.tfstate"
  }
  
}

variable "imagebuild" {
  type        = string
  description = "Latest Image Build"
}


resource "azurerm_resource_group" "tf_test" {
    name = "tfmainrg"
    location = "UK South"
}

resource "azurerm_container_group" "tfcg_test" {
    name                    = "weatherapi"
    location                = azurerm_resource_group.tf_test.location
    resource_group_name     = azurerm_resource_group.tf_test.name

    ip_address_type         = "public"
    dns_name_label          = "nigerninjawapi"
    os_type                 = "Linux"

    container {
        name                = "weatherapi"
        image               = "nigerninja/weatherapi:${var.imagebuild}"
            cpu             = "1"
            memory          = "1"

            ports {
                port        = 80
                protocol    = "TCP"
            }
    }
}