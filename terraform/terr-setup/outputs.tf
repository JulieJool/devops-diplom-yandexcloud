output "service_account_id" {
  value = yandex_iam_service_account.terr-sa.id
}

output "bucket_name" {
  value = yandex_storage_bucket.terraform-state-bucket.bucket
}

output "access_key" {
  value = yandex_iam_service_account_static_access_key.terr-sa-static-key.access_key
  sensitive = true
}

output "secret_key" {
  value = yandex_iam_service_account_static_access_key.terr-sa-static-key.secret_key
  sensitive = true
}
