resource google_storage_bucket archive {
  name     = "${data.google_client_config.config.project}-archive"
  location = "US"

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type          = "SetStorageClass"
      storage_class = "ARCHIVE"
    }
    condition {
      age = 1
    }
  }
}
