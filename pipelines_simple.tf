locals {
  # REMINDER: Manually link GCP & GitHub for new repos:
  # https://console.cloud.google.com/cloud-build/triggers/connect?project=zeepalnet&provider=github_app
  simple_terraform_pipelines = toset([
    "zeepalnet-dns"
  ])
}

data "http" "pipelines_simple" {
  for_each = local.simple_terraform_pipelines

  url = "https://raw.githubusercontent.com/ZeePal/${each.key}/master/cloudbuild.yaml"
}

module "pipelines_simple" {
  source   = "github.com/ZeePal/terraform-google-cloudbuild-verify-gpg"
  for_each = local.simple_terraform_pipelines

  source_build_template = yamldecode(data.http.pipelines_simple[each.key].response_body)
  signing_key           = file("signing_key.asc")

  github = {
    owner = "ZeePal"
    name  = each.key
    push = {
      branch = "^master$"
    }
  }
}
