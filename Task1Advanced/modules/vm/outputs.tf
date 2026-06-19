output "vm_id" {
  description = "ID виртуальной машины"
  value       = yandex_compute_instance.vm.id
}

output "vm_name" {
  description = "Имя виртуальной машины"
  value       = yandex_compute_instance.vm.name
}

output "vm_internal_ip" {
  description = "Внутренний IP-адрес ВМ"
  value       = yandex_compute_instance.vm.network_interface[0].ip_address
}

output "vm_external_ip" {
  description = "Внешний IP-адрес ВМ (если nat=true)"
  value       = yandex_compute_instance.vm.network_interface[0].nat_ip_address
}

output "disk_id" {
  description = "ID дополнительного диска"
  value       = yandex_compute_disk.additional_disk.id
}

output "disk_name" {
  description = "Имя дополнительного диска"
  value       = yandex_compute_disk.additional_disk.name
}

output "fqdn" {
  description = "FQDN виртуальной машины"
  value       = yandex_compute_instance.vm.fqdn
}

output "network_id" {
  description = "ID сети"
  value       = var.subnet_id != null ? null : yandex_vpc_network.network[0].id
}

output "subnet_id" {
  description = "ID подсети"
  value       = local.effective_subnet_id
}