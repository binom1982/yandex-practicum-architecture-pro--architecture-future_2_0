output "vm_id" {
  description = "ID ВМ в dev"
  value       = module.dev_vm.vm_id
}

output "vm_internal_ip" {
  description = "Внутренний IP ВМ в dev"
  value       = module.dev_vm.vm_internal_ip
}

output "vm_external_ip" {
  description = "Внешний IP ВМ в dev"
  value       = module.dev_vm.vm_external_ip
}

output "disk_id" {
  description = "ID диска в dev"
  value       = module.dev_vm.disk_id
}

output "subnet_id" {
  description = "ID подсети в dev"
  value       = module.dev_vm.subnet_id
}