# Создание сервисного аккаунта
resource "yandex_iam_service_account" "terr-sa" {
  folder_id   = var.folder_id
  name        = "terr-sa"
  description = "Service account for Terraform with necessary permissions"
}

# Назначение роли 
resource "yandex_resourcemanager_folder_iam_member" "editor-sa" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.terr-sa.id}"
  depends_on = [yandex_iam_service_account.terr-sa]
}

# Создание статического ключа доступа для сервисного аккаунта
resource "yandex_iam_service_account_static_access_key" "terr-sa-static-key" {
  service_account_id = yandex_iam_service_account.terr-sa.id
  description        = "Static access key for terr-sa"
}

# Создание бакета для хранения стейт-файла
resource "yandex_storage_bucket" "terraform-state-bucket" {
  bucket     = "terraform-state-bucket-of-julia-teplov"
  access_key = yandex_iam_service_account_static_access_key.terr-sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.terr-sa-static-key.secret_key
  acl    = "private"
  force_destroy = true
  depends_on = [yandex_resourcemanager_folder_iam_member.editor-sa]
}

resource "local_file" "credfile" {
  filename = "../terr-infra/creddata.key"
  content  = <<-EOT
    [default]
    aws_access_key_id = ${yandex_iam_service_account_static_access_key.terr-sa-static-key.access_key}
    aws_secret_access_key = ${yandex_iam_service_account_static_access_key.terr-sa-static-key.secret_key}
  EOT
}

# Создание JSON-ключа с PEM-ключами через CLI Yandex Cloud
resource "null_resource" "create_key_json" {
  provisioner "local-exec" {
    command = <<EOT
      yc iam key create \
        --service-account-id ${yandex_iam_service_account.terr-sa.id} \
        --output ../terr-infra/key.json
    EOT
  }
  depends_on = [yandex_iam_service_account.terr-sa]
}

# Чтение содержимого файла key.json
data "local_file" "key_json" {
  filename = "../terr-infra/key.json"

  depends_on = [null_resource.create_key_json]
}
