terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.8.4"

  backend "s3" {
    bucket   = "terraform-state-bucket-of-julia-teplov" # Укажите реальное имя бакета
    key      = "terraform.tfstate"                      # Путь к стейт-файлу в бакете
    region   = "ru-central1"                            # Регион Yandex Cloud
    endpoints = {
      s3 = "https://storage.yandexcloud.net"            # Endpoint для Object Storage
    }
    shared_credentials_files    = ["./creddata.key"]
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
  }

}

provider "yandex" {
  # token     = var.token
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.default_zone
  service_account_key_file = file("./key.json")
}
