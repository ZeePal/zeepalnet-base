locals {
  cloudbuild_iam_roles = toset([
    "iam.securityAdmin",
    "dns.admin"
  ])
}

resource google_project_iam_member cloudbuild {
  for_each = local.cloudbuild_iam_roles
  role     = "roles/${each.key}"
  member   = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}
