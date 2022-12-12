terraform {
  required_version = ">= 1.3.5"
  required_providers {
    google = { version = "~> 4.44" }

    # Beta provider used for:
    # * Cloud Build Trigger with GitHub functionality
    google-beta = { version = "~> 4.44" }

    http = { version = "~> 3.2" }
  }
}
