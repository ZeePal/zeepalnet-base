module "pipeline_base" {
  source = "github.com/ZeePal/terraform-google-cloudbuild-verify-gpg"

  source_build_template = yamldecode(file("cloudbuild.yaml"))
  signing_key           = file("signing_key.asc")

  github = {
    owner = "ZeePal"
    name  = "zeepalnet-base"
    push = {
      branch = "^master$"
    }
  }
}
