# --- Сеть ---
resource "yandex_vpc_network" "network" {
  count       = var.subnet_id == null ? 1 : 0
  name        = "${var.environment}-${var.network_name}"
  description = "Network for ${var.environment} environment"
}

resource "yandex_vpc_subnet" "subnet" {
  count          = var.subnet_id == null ? 1 : 0
  name           = "${var.environment}-${var.subnet_name}"
  zone           = var.zone
  network_id     = yandex_vpc_network.network[0].id
  v4_cidr_blocks = [var.subnet_cidr]
}

locals {
  effective_subnet_id = var.subnet_id != null ? var.subnet_id : yandex_vpc_subnet.subnet[0].id
}

# --- Дополнительный диск ---
resource "yandex_compute_disk" "additional_disk" {
  name     = "${var.vm_name}-data-disk"
  type     = "network-hdd"
  size     = var.disk_size
  zone     = var.zone
}

# --- Виртуальная машина ---
resource "yandex_compute_instance" "vm" {
  name        = var.vm_name
  platform_id = var.platform_id
  zone        = var.zone

  resources {
    cores         = var.cores
    memory        = var.memory
    core_fraction = var.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      type     = "network-hdd"
      size     = var.boot_disk_size
    }
  }

  network_interface {
    subnet_id = local.effective_subnet_id
    nat       = var.nat_enabled
  }

  secondary_disk {
    disk_id = yandex_compute_disk.additional_disk.id
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_key}"
    env      = var.environment
  }

  lifecycle {
    ignore_changes = [
      metadata,
    ]
  }
}