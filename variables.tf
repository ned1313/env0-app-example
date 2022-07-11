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
  type = string
  description = "(Required) Environment for Azure resources."
}
variable "common_tags" {
  type        = map(string)
  description = "(Optional) Tags to apply to all resources."
  default     = {}
}

variable "business_unit_tag" {
  type = string
  description = "(Optional) BU tag to apply to all resources."
  default = null
}

variable "organization_tag" {
  type = string
  description = "(Optional) Org tag to apply to all resources."
  default = null
}

variable "vm_size" {
  type = string
  description = "(Optional) VM size for app."
  default = "Standard_D2s_v4"
}

variable "admin_username" {
    type        = string
    description = "(Required) Username for the admin user."
}
variable "admin_password" {
    type = string
    description = "(Required) Password for the admin user."
    sensitive = true
}

variable "app_subnet_id" {
  type = string
  desdescription = "(Required) Subnet ID for the app."  
}

variable "app_port_number" {
  type = number
  description = "(Optional) Port number for app. Defaults to 8000."
  default = 8000
}