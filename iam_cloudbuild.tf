locals {
  cloudbuild_iam_roles = toset([
    "compute.admin",
    "dns.admin",
    "iam.securityAdmin",
    "iam.serviceAccountUser",
    "iap.tunnelResourceAccessor",
    "serviceusage.serviceUsageAdmin",
    "storage.admin"
  ])
}

data "google_project" "current" {}

resource "google_project_iam_member" "cloudbuild" {
  for_each = local.cloudbuild_iam_roles

  project = data.google_project.current.project_id
  role    = "roles/${each.key}"
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}
