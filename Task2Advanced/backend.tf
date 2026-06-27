terraform {
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net" # Эндпоинт S3-совместимого хранилища (Yandex Cloud)
    }
    bucket = "future20-terraform-state-1"      # Имя бакета, созданного для хранения стейта
    region = "ru-central1"
    key    = "prod/terraform.tfstate"        # Путь к файлу состояния внутри бакета

    # Флаги, необходимые для корректной работы с S3-совместимыми хранилищами (YC / MinIO)
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}