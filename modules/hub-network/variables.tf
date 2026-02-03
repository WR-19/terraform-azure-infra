variable "env" {
  description = "Environment (dev/prod)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}