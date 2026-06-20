




### Как передать эти ключи в Terraform?

**Поскольку Terraform ожидает ключи в формате AWS, вам нужно «скормить» ему статические ключи от Яндекс Облака. Это можно сделать двумя способами:**

**Способ 1: Через переменные окружения (Рекомендуется для CI/CD)**
Перед запуском `terraform init` и `terraform apply` в терминале (или в настройках секретов GitHub Actions/GitLab CI) нужно задать переменные:


```bash
export AWS_ACCESS_KEY_ID="ваш_Key_ID"
export AWS_SECRET_ACCESS_KEY="ваш_Secret_Key"
```
