variable "env" {
  type = string
}

variable "suffix" {
  description = "Unique suffix for KV name"
  type        = string
}

variable "location" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "subnet_ids" {
  description = "Subnets allowed to access KV"
  type        = list(string)
}