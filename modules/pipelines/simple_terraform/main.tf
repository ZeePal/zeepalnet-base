locals {
  terraform_docker_image = var.override_terraform_docker_image == "" ? "hashicorp/terraform:${var.terraform_version}" : var.override_terraform_docker_image
  terraform_env_vars = concat([
    "GOOGLE_PROJECT=${var.project_id}",
    "GOOGLE_REGION=${var.region}"
  ], var.extra_env_vars)
  git_verify_image = "gcr.io/$PROJECT_ID/git-verify"
}

resource google_cloudbuild_trigger pipeline {
  provider = google-beta

  name = var.repo_name

  github {
    owner = var.repo_owner
    name  = var.repo_name
    push {
      branch = "^master$"
    }
  }

  build {
    # TODO: Remove workaround for missing .git folder once google has fixed:
    ## https://github.com/GoogleCloudPlatform/cloud-builders/issues/236
    ## https://issuetracker.google.com/issues/136435027#comment17
    step {
      id         = "fetch missing .git folder"
      name       = "gcr.io/cloud-builders/git"
      entrypoint = "bash"
      args = [
        "-c",
        <<EOS
git init
git remote add origin https://github.com/${var.repo_owner}/$REPO_NAME.git
git fetch --depth=1 origin $COMMIT_SHA
git reset --hard FETCH_HEAD
EOS
      ]
    }

    step {
      id   = "git verify"
      name = local.git_verify_image
      args = [
        "verify-commit", "HEAD"
      ]
    }

    step {
      id   = "terraform init"
      name = local.terraform_docker_image
      args = [
        "init",
        "-backend-config=bucket=${var.tfstate_bucket_name}",
        "-backend-config=prefix=$REPO_NAME"
      ]
      env = local.terraform_env_vars
    }

    step {
      id   = "terraform apply"
      name = local.terraform_docker_image
      args = [
        "apply",
        "-parallelism=1000",
        "-auto-approve"
      ]
      env = local.terraform_env_vars
    }
  }
}
