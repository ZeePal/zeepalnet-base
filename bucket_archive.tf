resource "google_storage_bucket" "archive" {
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

  # Extra soft failsafe against deletions WITHOUT locking the policy to the bucket...
  retention_policy {
    # "The value must be less than 2,147,483,647 seconds."
    retention_period = 2147483646
  }
}
