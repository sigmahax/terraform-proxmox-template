# Terraform Project Template

This is a slightly opinionated terraform project template with a proxmox virtual machine as an example.

## Setup Repository

0. Install dependencies
   * terraform, sops, age
1. Generate age key
   * `age-keygen -o age.agekey`
   * `mkdir -p ~/.config/sops/age`
   * `mv age.agekey ~/.config/sops/age/keys.txt`
     * Multiple keys can be stored in this file, in that case use:
     * `cat age.agekey >> ~/.config/sops/age/keys.txt`
     * `rm age.agekey`
   * (If using TF Cloud) Add age key as sensitive 
2. Update Variables
   * Within the file: `terraform/main.tf` (if using cloud, otherwise remove)
     * Update terraform.cloud.organization
     * Update terraform.cloud.workspaces.name
   * Secrets file: `terraform/secret.sops.yaml`
   * Config file: `.sops.yaml`
     * Update age-public-key
3. Encrypt Secrets
   * `sops -e -i terraform/secret.sops.yaml`
     * To decrypt: `sops -d -i terraform/secret.sops.yaml`
   * NOTE: The `-i` flag means in-place. Without this, it will simply cat the result to stdout
4. Terraform
   * `cd terraform`
   * `terraform login`
     * Follow link to get token
   * `terraform init`
   * `terraform plan`
     * At this point we are expecting an existing template on proxmox (create a VM -> convert to template)
   * `terraform apply`
     * NOTE: The example proxmox vm provided is partially broken. Unsure if it is a config bug or provider bug, but it doesn't appear to be able to find the resource after creation (same with imports). Possible that the proxmox API client needs updating. The resource though is still created.
5. (As Needed) Terraform Imports
   * It is best to reference the provider's documentation for the specific resource type. General process is:
     1. Create `resource` block in a `.tf` file with a type and a name. No attributes needed yet.
     2. Run `terraform import <resource_type>.<resource_name> <resource_id>`
        * Importing a module's resources: `terraform import <resource_type>.<resource_name> <resource_id>`
        * Resource id is some unique identifier for the resource on it's own platform, i.e. VM_ID or VM_NAME
        * The proxmox provider: [docs](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs)
          * `terraform import [options] [node]/[type]/[vmId]

## Optional
1. Pre-commit
2. Github actions