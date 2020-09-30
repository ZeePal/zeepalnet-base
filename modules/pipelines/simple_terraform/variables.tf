variable region {
  description = "Which GCP Region should be the default for the pipeline?"
}

variable project_id {
  description = "What GCP Project ID should be the default for the pipeline?"
}

variable repo_owner {
  description = "What is the GitHub Owner Name?"
}

variable repo_name {
  description = "What is the GitHub Repo Name?"
}

variable tfstate_bucket_name {
  description = "What is the GCS Bucket Name to store our pipelines Terraform State?"
}

variable terraform_version {
  description = "What version of terraform should we use?"
  default     = "0.13.3"
}
