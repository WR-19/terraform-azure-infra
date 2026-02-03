terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstatewr"
    container_name       = "tfstate"
    key                  = "dev.tfstate"
  }
}

provider "azurerm" {
  features {}
}

module "hub" {
  source   = "../../modules/hub-network"
  env      = "dev"
  location = var.location
}

module "spoke_web" {
  source = "../../modules/spoke-network"
  
  env         = "dev"
  name        = "web"
  location    = var.location
  cidr        = "10.1.0.0/16"
  app_subnet  = "10.1.1.0/24"
  data_subnet = "10.1.2.0/24"
  
  hub_vnet_id   = module.hub.vnet_id
  hub_vnet_name = module.hub.vnet_name
  hub_rg_name   = module.hub.rg_name
}

module "spoke_api" {
  source = "../../modules/spoke-network"
  
  env         = "dev"
  name        = "api"
  location    = var.location
  cidr        = "10.2.0.0/16"
  app_subnet  = "10.2.1.0/24"
  data_subnet = "10.2.2.0/24"
  
  hub_vnet_id   = module.hub.vnet_id
  hub_vnet_name = module.hub.vnet_name
  hub_rg_name   = module.hub.rg_name
}

module "kv_web" {
  source = "../../modules/security"
  
  env      = "dev"
  suffix   = "web01"
  location = var.location
  rg_name  = module.spoke_web.rg_name
  
  subnet_ids = [
    module.spoke_web.app_subnet_id
  ]
}