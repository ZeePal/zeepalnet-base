module pipeline_swarm_test {
  source = "./modules/pipelines/simple_terraform"

  region              = data.google_client_config.config.region
  project_id          = data.google_client_config.config.project
  tfstate_bucket_name = google_storage_bucket.tfstate.name

  repo_owner = "ZeePal"
  repo_name  = "zeepalnet-gcp-swarm-test"

  override_terraform_docker_image = "gcr.io/$PROJECT_ID/terraform-with-gcloud-ssh"

  extra_env_vars = [
    "TF_VAR_host=swarm-1",
    "CLOUDSDK_COMPUTE_ZONE=us-west1-a",
    "TF_LOG=trace"
  ]
}
