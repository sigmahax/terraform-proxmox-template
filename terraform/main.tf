terraform {
    required_providers {
        proxmox = {
            source = "telmate/proxmox"
            version = "2.9.11"
        }
        sops = {
            source  = "carlpett/sops"
            version = "0.7.1"
        }
    }
    cloud {
        organization = "<org-name>"
        workspaces {
            name = "<workspace-name>"
        }
    }
}

data "sops_file" "secrets" {
    source_file = "secret.sops.yaml"
}

module "sample_prox_vm_spec" {
    proxmox_node_name = data.sops_file.secrets.data["proxmox_node_name"]
    proxmox_fast_storage = data.sops_file.secrets.data["proxmox_fast_storage"]
    proxmox_slow_storage = data.sops_file.secrets.data["proxmox_slow_storage"]
    sample_vm_macaddr = data.sops_file.secrets.data["sample_vm_macaddr"]
    sample_vm_vlantag = data.sops_file.secrets.data["sample_vm_vlantag"]
    source = "./core/sample-prox-vm-spec"
}

module "sample_app_spec" {
    exported_core_var = module.sample_prox_vm_spec.exported_core_var
    sample_app_var = data.sops_file.secrets.data["sample_app_var"]
    source = "./apps/sample-app-spec"
}
