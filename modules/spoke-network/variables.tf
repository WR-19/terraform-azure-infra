variable "env" {
  type = string
}

variable "name" {
  description = "Spoke name (api, web, etc)"
  type        = string
}

variable "location" {
  type = string
}

variable "cidr" {
  description = "VNet CIDR block"
  type        = string
}

variable "app_subnet" {
  type = string
}

variable "data_subnet" {
  type = string
}

variable "hub_vnet_id" {
  type = string
}

variable "hub_vnet_name" {
  type = string
}

variable "hub_rg_name" {
  type = string
}