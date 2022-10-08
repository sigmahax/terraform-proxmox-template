variable "proxmox_node_name" {
  type      = string
  sensitive = false
}

variable "proxmox_fast_storage" {
  type      = string
  sensitive = false
}

variable "proxmox_slow_storage" {
  type      = string
  sensitive = false
}

variable "sample_vm_macaddr" {
  type      = string
  sensitive = true
}

variable "sample_vm_vlantag" {
  type      = string
  sensitive = true
}
