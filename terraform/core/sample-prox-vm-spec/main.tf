terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.11"
    }
  }
}

resource "proxmox_vm_qemu" "sample_vm" {
  name        = "sample-vm"
  target_node = var.proxmox_node_name
  desc        = "Sample VM Created with Talos ISO"

  iso     = "local:iso/talos-amd64-1.2.3.iso" # Must be format <storage_pool>:iso/<iso_filename>
  memory  = "6144"
  sockets = 1
  cores   = 8
  cpu     = "host" # Prevents live migration if using host cpu type
  numa    = true
  hotplug = "disk,memory"

  network {
    model    = "virtio"
    macaddr  = var.sample_vm_macaddr
    bridge   = "vmbr0"
    tag      = var.sample_vm_vlantag
    firewall = true
  }

  disk {
    type    = "scsi"
    storage = var.proxmox_fast_storage
    size    = "8G"
    ssd     = 1
  }

  disk {
    type    = "scsi"
    storage = var.proxmox_slow_storage
    size    = "88G"
  }

  onboot   = true
  oncreate = true
}