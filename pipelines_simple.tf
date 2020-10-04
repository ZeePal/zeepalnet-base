locals {
  # REMINDER: Manually link GCP & GitHub for new repos:
  # https://console.cloud.google.com/cloud-build/triggers/connect?project=zeepalnet&provider=github_app
  simple_terraform_pipelines = {
    "zeepalnet-dns" = ["TF_VAR_domain=${var.domain}"]
    "zeepalnet-gcp-swarm" = [
      "GOOGLE_ZONE=us-west1-a",
      "TF_VAR_domain=${var.domain}",
    ]
  }
}

module pipelines_simple {
  source   = "./modules/pipelines/simple_terraform"
  for_each = local.simple_terraform_pipelines

  region              = data.google_client_config.config.region
  project_id          = data.google_client_config.config.project
  tfstate_bucket_name = google_storage_bucket.tfstate.name

  repo_owner = "ZeePal"
  repo_name  = each.key

  extra_env_vars = each.value
}
