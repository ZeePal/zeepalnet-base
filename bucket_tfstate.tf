resource "google_storage_bucket" "tfstate" {
  name     = "${data.google_client_config.config.project}-tfstate"
  location = data.google_client_config.config.region

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age                = 3
      num_newer_versions = 1
    }
  }
}
