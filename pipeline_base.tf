module "pipeline_base" {
  source = "./modules/pipelines/base"

  region              = data.google_client_config.config.region
  project_id          = data.google_client_config.config.project
  tfstate_bucket_name = google_storage_bucket.tfstate.name

  repo_owner = "ZeePal"
  repo_name  = "zeepalnet-base"

  extra_env_vars = ["TF_VAR_domain=${var.domain}"]
}
