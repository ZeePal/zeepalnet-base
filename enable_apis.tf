locals {
  enable_gcp_apis = toset([
    "cloudresourcemanager.googleapis.com",
    "cloudbuild.googleapis.com"
  ])
}

resource google_project_service api {
  for_each = local.enable_gcp_apis
  service  = each.key

  disable_on_destroy = false
}
