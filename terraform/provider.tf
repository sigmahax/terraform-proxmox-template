provider "proxmox" {
    pm_api_url  = data.sops_file.secrets.data["proxmox_api_url"]
    pm_user     = data.sops_file.secrets.data["proxmox_user"]
    pm_password = data.sops_file.secrets.data["proxmox_pass"]
}