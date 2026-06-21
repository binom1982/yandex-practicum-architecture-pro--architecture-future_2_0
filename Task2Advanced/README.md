# Интеграция с CI/CD и удалённым хранением состояния

## Описание проекта

Данный проект демонстрирует автоматизацию развёртывания инфраструктуры Yandex Cloud с использованием Terraform и CI/CD пайплайна (GitHub Actions).

**Ключевые особенности:**

- Удалённое хранение состояния Terraform в S3-совместимом хранилище (Yandex Object Storage)
- Автоматизация через GitHub Actions с этапами `plan` и `apply`
- Ручное подтверждение (manual approval) перед применением изменений
- Безопасное управление секретами через GitHub Secrets
- Переиспользование модуля из Task 1

---

## Структура проекта

```bash
Task2Advanced/
├── backend.tf              # Настройки удалённого хранилища состояния (из Шага 1)
├── provider.tf             # Настройки провайдера Yandex Cloud
├── main.tf                 # Основной код инфраструктуры
├── variables.tf            # Входные переменные
├── outputs.tf              # Выходные значения
├── terraform.tfvars        # Значения переменных
└── .github/workflows/
    └── terraform.yml       # CI/CD пайплайн (GitHub Actions)
```

---

## Предварительные требования

### 1. Yandex Cloud

- Аккаунт в [Yandex Cloud](https://console.yandex.cloud/)
- Созданное облако и каталог (folder)
- Включённый биллинг (или стартовый грант)

### 2. Yandex Object Storage (для backend)

Создайте бакет для хранения состояния Terraform:

1. Перейдите в **Object Storage** в консоли Yandex Cloud
2. Создайте бакет с уникальным именем (например, `my-terraform-state-12345`)
3. Выберите **Частный** доступ
4. Запомните имя бакета — оно понадобится для `backend.tf`

### 3. Сервисный аккаунт для Object Storage

Создайте сервисный аккаунт для доступа к бакету:

```bash
# Создание сервисного аккаунта
yc iam service-account create --name terraform-sa

# Назначение роли для работы с Object Storage
yc resource-manager folder add-access-binding <FOLDER_ID> \
  --role storage.editor \
  --subject serviceAccount:<SERVICE_ACCOUNT_ID>

# Создание статических ключей доступа
yc iam access-key create --service-account-name terraform-sa
```

### 4. SSH-ключ

Создайте SSH-ключ для доступа к виртуальным машинам:

```bash
ssh-keygen -t ed25519 -C "terraform-ci@example.com"
cat ~/.ssh/id_ed25519.pub
```

### Настройка backend (удалённое хранение состояния)

Файл backend.tf настраивает Terraform для хранения состояния в Yandex Object Storage:

```bash
terraform {
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = "my-terraform-state-12345"  # Замените на имя вашего бакета
    region = "ru-central1"
    key    = "prod/terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
```


## Настройка CI/CD пайплайна

### Файл `.github/workflows/terraform.yml`

**Пайплайн состоит из двух job'ов:**

#### Job 1: `plan` (автоматический)

**Запускается при:**

* **Push в ветку **`main`
* **Создании/обновлении Pull Request**

**Этапы:**

1. `terraform init` — инициализация провайдеров и backend
2. `terraform fmt -check` — проверка форматирования кода
3. `terraform validate` — валидация конфигурации
4. `terraform plan` — построение плана изменений
5. **Сохранение плана как артефакт**

#### Job 2: `apply` (требует ручного подтверждения)

**Запускается только после:**

* **Успешного завершения job **`plan`
* **Ручного подтверждения reviewer'ом (через GitHub Environment)**

**Этапы:**

1. `terraform init` — повторная инициализация
2. **Загрузка плана из артефакта**
3. `terraform apply` — применение плана

### Настройка GitHub Environment

1. **Перейдите в ****Settings → Environments → New environment**
2. **Создайте окружение **`production`
3. **Включите ****Required reviewers** и укажите себя как reviewer
4. **Это обеспечит manual approval перед **`terraform apply`

---

## Необходимые секреты GitHub

**Добавьте следующие секреты в ** **Settings → Secrets and variables → Actions** **:**

| **Название секрета** | **Описание**                                          | **Где взять**                                                                                                                           |
| ----------------------------------------- | ------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| `YC_TOKEN`                              | **OAuth токен Yandex Cloud**                             | [OAuth страница](https://oauth.yandex.ru/authorize?response_type=token&client_id=1a6990aa636648e9b2ef855fa7bec2fb)или `yc iam create-token` |
| `YC_CLOUD_ID`                           | **ID облака**                                           | **Консоль YC → Облако → ID**                                                                                                     |
| `YC_FOLDER_ID`                          | **ID каталога**                                       | **Консоль YC → Каталог → ID**                                                                                                   |
| `AWS_ACCESS_KEY_ID`                     | **Key ID статического ключа Object Storage** | `yc iam access-key create --service-account-name terraform-sa`                                                                                      |
| `AWS_SECRET_ACCESS_KEY`                 | **Secret Key статического ключа**            | **То же, что выше**                                                                                                                  |
| `SSH_PUBLIC_KEY`                        | **Публичный SSH-ключ**                           | `cat ~/.ssh/id_ed25519.pub`                                                                                                                         |
