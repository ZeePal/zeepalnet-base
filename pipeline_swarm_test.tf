module pipeline_swarm_test {
  source = "./modules/pipelines/simple_terraform"

  region              = data.google_client_config.config.region
  project_id          = data.google_client_config.config.project
  tfstate_bucket_name = google_storage_bucket.tfstate.name

  repo_owner = "ZeePal"
  repo_name  = "zeepalnet-gcp-swarm-test"

  override_terraform_docker_image = "gcr.io/$PROJECT_ID/terraform-with-gcloud-ssh"
}
