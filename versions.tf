terraform {
  required_version = ">= 0.13"
  required_providers {
    google = { version = "~> 3.41" }

    # Beta provider used for:
    # * Cloud Build Trigger with GitHub functionality
    google-beta = { version = "~> 3.41" }
  }
}
