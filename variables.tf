variable "prefix" {
  type        = string
  description = "(Required) Naming prefix for resources."
}

variable "location" {
  type        = string
  description = "(Optional) Region for Azure resources, defaults to East US."
  default     = "eastus"
}

variable "environment" {
  type        = string
  description = "(Required) Environment for Azure resources."
}
variable "common_tags" {
  type        = map(string)
  description = "(Optional) Tags to apply to all resources."
  default     = {}
}

variable "business_unit_tag" {
  type        = string
  description = "(Optional) BU tag to apply to all resources."
  default     = null
}

variable "organization_tag" {
  type        = string
  description = "(Optional) Org tag to apply to all resources."
  default     = null
}

variable "vm_size" {
  type        = string
  description = "(Optional) VM size for app. Defaults to Standard_D2s_v5."
  default     = "Standard_D2s_v5"
}

variable "admin_username" {
  type        = string
  description = "(Required) Username for the admin user."
}
variable "admin_password" {
  type        = string
  description = "(Required) Password for the admin user."
  sensitive   = true
}

variable "vnet_address_space" {
  type        = list(string)
  description = "(Required) Address space for the virtual network."
}

variable "subnet_map" {
  type        = map(string)
  description = "(Required) Map of subnet names and address spaces."
}

variable "app_subnet" {
  type        = string
  description = "(Required) Name of subnet for app VM deployment. Must also be in keys from subnet_map."
}

variable "app_port_number" {
  type        = number
  description = "(Optional) Port number for app. Defaults to 8000."
  default     = 8000
}