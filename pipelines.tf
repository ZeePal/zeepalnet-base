locals {
  simple_terraform_pipelines = toset([
    "zeepalnet-base" # Me!
  ])
}

module pipelines {
  source   = "./modules/pipelines/simple_terraform"
  for_each = local.simple_terraform_pipelines

  region              = data.google_client_config.config.region
  project_id          = data.google_client_config.config.project
  tfstate_bucket_name = google_storage_bucket.tfstate.name

  repo_owner = "ZeePal"
  repo_name  = each.key
}
