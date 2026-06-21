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

# Получаем актуальный ID образа Ubuntu 22.04 LTS
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

# Используем модуль из Задания 1 для создания ВМ
module "vm_instance" {
  source = "../Task1Advanced/modules/vm"
  
  vm_name     = "${var.environment}-app-server"
  environment = var.environment        
  cores       = var.vm_cores           
  memory      = var.vm_memory          
  disk_size   = var.disk_size
  subnet_id   = yandex_vpc_subnet.subnet.id
  ssh_key     = var.ssh_public_key     
  zone        = var.zone
  image_id    = data.yandex_compute_image.ubuntu.id  # ✅ Динамический ID
}