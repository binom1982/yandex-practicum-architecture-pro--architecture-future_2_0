terraform {
  required_version = ">= 1.0.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.100.0"
    }
  }
}

provider "yandex" {
  zone = var.zone
}

module "prod_vm" {
  source = "../../modules/vm"

  vm_name     = "prod-vm-01"
  environment = "prod"
  cores       = var.cores
  memory      = var.memory
  disk_size   = var.disk_size
  subnet_id   = var.subnet_id
  ssh_key     = var.ssh_key
  zone        = var.zone
}