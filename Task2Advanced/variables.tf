variable "yc_token" {
  description = "OAuth токен для Yandex Cloud"
  type        = string
  sensitive   = true
}

variable "cloud_id" {
  description = "ID облака в Yandex Cloud"
  type        = string
  default     = "your-cloud-id"
}

variable "folder_id" {
  description = "ID каталога в Yandex Cloud"
  type        = string
  default     = "your-folder-id"
}

variable "zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "environment" {
  description = "Окружение (dev, stage, prod)"
  type        = string
  default     = "dev"
}

variable "vm_cores" {
  description = "Количество ядер ВМ"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Объём RAM в ГБ"
  type        = number
  default     = 2
}

variable "disk_size" {
  description = "Размер диска в ГБ"
  type        = number
  default     = 20
}

variable "ssh_public_key" {
  description = "Публичный SSH-ключ для доступа к ВМ"
  type        = string
  default     = "ssh-rsa AAAA..."
}