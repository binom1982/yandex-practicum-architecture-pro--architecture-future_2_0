variable "vm_name" {
  description = "Имя виртуальной машины"
  type        = string
}

variable "environment" {
  description = "Окружение (dev/stage/prod)"
  type        = string
}

variable "cores" {
  description = "Количество ядер процессора"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Объём оперативной памяти в ГБ"
  type        = number
  default     = 4
}

variable "disk_size" {
  description = "Размер подключаемого диска в ГБ"
  type        = number
  default     = 50
}

variable "subnet_id" {
  description = "ID подсети для подключения ВМ (опционально, если не задан — создаётся новая)"
  type        = string
  default     = null
}

variable "network_name" {
  description = "Имя создаваемой сети (используется, если subnet_id не задан)"
  type        = string
  default     = "default-network"
}

variable "subnet_name" {
  description = "Имя создаваемой подсети"
  type        = string
  default     = "default-subnet"
}

variable "subnet_cidr" {
  description = "CIDR создаваемой подсети"
  type        = string
  default     = "10.0.0.0/24"
}

variable "ssh_key" {
  description = "Публичный SSH-ключ для доступа к ВМ"
  type        = string
}

variable "image_id" {
  description = "ID образа для создания ВМ"
  type        = string
  default     = "fd8vmcue7aajpmeo39kk" # Ubuntu 22.04 LTS
}

variable "platform_id" {
  description = "Платформа ВМ"
  type        = string
  default     = "standard-v3"
}

variable "zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "core_fraction" {
  description = "Доля CPU (процентов)"
  type        = number
  default     = 100
}

variable "boot_disk_size" {
  description = "Размер загрузочного диска в ГБ"
  type        = number
  default     = 20
}

variable "nat_enabled" {
  description = "Назначать ли ВМ публичный IP"
  type        = bool
  default     = true
}