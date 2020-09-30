provider google {
  version = "~> 3.41"
}

# Beta provider used for:
# * Cloud Build Trigger with GitHub functionality
provider google-beta {
  version = "~> 3.41"
}

data google_client_config config {}
