locals {
  terraform_docker_image = "hashicorp/terraform:${var.terraform_version}"
  common_env_vars = [
    "GOOGLE_PROJECT=$_GOOGLE_PROJECT",
    "GOOGLE_REGION=$_GOOGLE_REGION"
  ]
  git_verify_image = "asia.gcr.io/$PROJECT_ID/git-verify"
}

resource google_cloudbuild_trigger base {
  provider = google-beta

  name = var.repo_name

  github {
    owner = var.repo_owner
    name  = var.repo_name
    push {
      branch = "^master$"
    }
  }

  substitutions = {
    _TFSTATE_BUCKET = var.tfstate_bucket_name
    _GOOGLE_PROJECT = var.project_id
    _GOOGLE_REGION  = var.region
  }

  build {
    step {
      id   = "git verify"
      name = local.git_verify_image
      args = [
        "verify-commit", "HEAD"
      ]
    }

    step {
      id   = "build git verify image"
      name = "gcr.io/cloud-builders/docker"
      args = [
        "build",
        "-t", "${local.git_verify_image}:latest",
        "--cache-from", "${local.git_verify_image}:latest",
        "docker/git-verify/"
      ]
    }

    step {
      id   = "terraform init"
      name = local.terraform_docker_image
      args = [
        "init",
        "-backend-config=bucket=$_TFSTATE_BUCKET",
        "-backend-config=prefix=$REPO_NAME"
      ]
      env = local.common_env_vars
    }

    step {
      id   = "terraform apply"
      name = local.terraform_docker_image
      args = [
        "apply",
        "-parallelism=1000",
        "-auto-approve"
      ]
      env = local.common_env_vars
    }
  }
}