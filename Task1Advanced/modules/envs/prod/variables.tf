variable "cores" {
  description = "Количество ядер"
  type        = number
  default     = 8
}

variable "memory" {
  description = "Объём RAM (ГБ)"
  type        = number
  default     = 16
}

variable "disk_size" {
  description = "Размер диска (ГБ)"
  type        = number
  default     = 200
}

variable "subnet_id" {
  description = "ID подсети (null — создать новую)"
  type        = string
  default     = null
}

variable "ssh_key" {
  description = "SSH-ключ"
  type        = string
  sensitive   = true
}

variable "zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}