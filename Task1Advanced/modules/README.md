# Модульная инфраструктура для нескольких сред

## Описание

Универсальный модуль Terraform для создания виртуальных машин в Yandex Cloud
с подключаемым диском и сетью. Модуль поддерживает три окружения —
`dev`, `stage` и `prod` — с разными конфигурациями ресурсов.

## Параметры модуля `modules/vm`

Входные параметры (`variables.tf`)

| Параметр   | Тип | По умолчанию  | Описание                                                      |
| ------------------ | ------ | ------------------------ | --------------------------------------------------------------------- |
| `vm_name`        | string | —                       | Имя виртуальной машины                            |
| `environment`    | string | —                       | Окружение (`dev` / `stage` / `prod`)                   |
| `cores`          | number | `2`                    | Количество ядер процессора                    |
| `memory`         | number | `4`                    | Объём RAM, ГБ                                                  |
| `disk_size`      | number | `50`                   | Размер подключаемого диска, ГБ              |
| `subnet_id`      | string | `null`                 | ID подсети. Если `null` — создаётся новая |
| `network_name`   | string | `default-network`      | Имя создаваемой сети                                |
| `subnet_name`    | string | `default-subnet`       | Имя создаваемой подсети                          |
| `subnet_cidr`    | string | `10.0.0.0/24`          | CIDR создаваемой подсети                            |
| `ssh_key`        | string | —                       | Публичный SSH-ключ                                       |
| `image_id`       | string | `fd8vmcue7aajpmeo39kk` | ID образа ОС (Ubuntu 22.04 LTS)                               |
| `platform_id`    | string | `standard-v3`          | Платформа ВМ                                               |
| `zone`           | string | `ru-central1-a`        | Зона доступности                                       |
| `core_fraction`  | number | `100`                  | Доля CPU, %                                                       |
| `boot_disk_size` | number | `20`                   | Размер загрузочного диска, ГБ                |
| `nat_enabled`    | bool   | `true`                 | Назначать ли публичный IP                         |

Выходы (`outputs.tf`)

| Выход         | Описание                                                   |
| ------------------ | ------------------------------------------------------------------ |
| `vm_id`          | ID виртуальной машины                             |
| `vm_name`        | Имя ВМ                                                        |
| `vm_internal_ip` | Внутренний IP                                            |
| `vm_external_ip` | Внешний IP (если `nat_enabled = true`)                |
| `disk_id`        | ID дополнительного диска                       |
| `disk_name`      | Имя дополнительного диска                   |
| `fqdn`           | FQDN ВМ                                                          |
| `network_id`     | ID созданной сети                                     |
| `subnet_id`      | ID подсети (созданной или переданной) |

Конфигурации окружений

| Окружение | vCPU | RAM, ГБ | Диск, ГБ | Назначение                                  |
| ------------------ | ---- | --------- | -------------- | ----------------------------------------------------- |
| `dev`            | 2    | 4         | 50             | Разработка и локальные тесты |
| `stage`          | 4    | 8         | 100            | Предпродажное тестирование   |
| `prod`           | 8    | 16        | 200            | Промышленная эксплуатация     |

Предварительные требования

1. Terraform `>= 1.0.0`
2. Провайдер Yandex Cloud:

   ```bash
   export YC_TOKEN=$(yc iam create-token)
   export YC_CLOUD_ID=<cloud-id>
   export YC_FOLDER_ID=<folder-id>
   ```

## Запуск

Развёртывание окружения

```bash
# Пример для dev. Аналогично для stage и prod.
cd envs/dev
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

Просмотр выходов

```bash
terraform output
```

Удаление ресурсов

```bash
terraform destroy -var-file=terraform.tfvars
```
