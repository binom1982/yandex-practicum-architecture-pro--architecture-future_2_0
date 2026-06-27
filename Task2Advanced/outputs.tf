output "vm_id" {
  description = "ID созданной виртуальной машины"
  value       = module.vm_instance.vm_id
}

output "vm_external_ip" {
  description = "Внешний IP-адрес виртуальной машины"
  value       = module.vm_instance.vm_external_ip
}

output "vm_internal_ip" {
  description = "Внутренний IP-адрес виртуальной машины"
  value       = module.vm_instance.vm_internal_ip
}

output "disk_id" {
  description = "ID подключенного диска"
  value       = module.vm_instance.disk_id
}

output "network_id" {
  description = "ID созданной сети"
  value       = yandex_vpc_network.network.id
}

output "subnet_id" {
  description = "ID созданной подсети"
  value       = yandex_vpc_subnet.subnet.id
}