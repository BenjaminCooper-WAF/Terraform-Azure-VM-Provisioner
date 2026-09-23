variable "location" {
  type    = string
  default = "var.location"
}

variable "admin_username" {
  type    = string
  default = "azureadmin"
}

variable "ssh_public_key" {
  description = "Public SSH key"
  type        = string
  sensitive   = true

  # Never hardcode your SSH public key in production. Use a secure method to provide it, such as environment variables or secret management tools.
  default = "ssh-ed25519 Xxxxxx/xxx"
}

variable "my_ip" {
  description = "My public IP for SSH access"
  type        = string
}