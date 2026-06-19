output "vm_id" {
  description = "ID ВМ в stage"
  value       = module.stage_vm.vm_id
}

output "vm_internal_ip" {
  description = "Внутренний IP ВМ в stage"
  value       = module.stage_vm.vm_internal_ip
}

output "vm_external_ip" {
  description = "Внешний IP ВМ в stage"
  value       = module.stage_vm.vm_external_ip
}

output "disk_id" {
  description = "ID диска в stage"
  value       = module.stage_vm.disk_id
}

output "subnet_id" {
  description = "ID подсети в stage"
  value       = module.stage_vm.subnet_id
}