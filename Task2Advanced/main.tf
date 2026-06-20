# Создаём сеть
resource "yandex_vpc_network" "network" {
  name = "${var.environment}-network"
}

# Создаём подсеть
resource "yandex_vpc_subnet" "subnet" {
  name           = "${var.environment}-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.1.0/24"]
}

# Используем модуль из Задания 1 для создания ВМ
module "vm_instance" {
  source = "../Task1Advanced/modules/vm"
  
  vm_name        = "${var.environment}-app-server"
  vm_cores       = var.vm_cores
  vm_memory      = var.vm_memory
  disk_size      = var.disk_size
  subnet_id      = yandex_vpc_subnet.subnet.id
  ssh_public_key = var.ssh_public_key
  zone           = var.zone
  image_family   = "ubuntu-2204-lts"
}