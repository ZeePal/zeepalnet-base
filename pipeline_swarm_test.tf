module pipeline_swarm_test {
  source = "./modules/pipelines/terraform_with_gcloud_ssh"

  region              = "us-west1"
  project_id          = data.google_client_config.config.project
  tfstate_bucket_name = google_storage_bucket.tfstate.name

  repo_owner = "ZeePal"
  repo_name  = "zeepalnet-gcp-swarm-test"

  extra_env_vars = [
    "TF_VAR_host=swarm-1",
    #"CLOUDSDK_COMPUTE_ZONE=us-west1-a"
  ]
}
