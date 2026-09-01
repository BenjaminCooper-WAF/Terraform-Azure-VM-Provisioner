variable "location" {
  type    = string
  default = "UK South"
}

variable "admin_username" {
  type    = string
  default = "azureadmin"
}

variable "ssh_public_key" {
  description = "Public SSH key"
  type        = string
  sensitive   = true

  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO1+P0L5PbZj0YdKPhLt9mPuejNJtYDAQE6UMwhNl6XZ Specu@Benjamin"

}
