locals {
  enable_gcp_apis = toset([
    "dns.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "serviceusage.googleapis.com"
  ])
}

resource google_project_service api {
  for_each = local.enable_gcp_apis
  service  = each.key

  disable_on_destroy = false
}
