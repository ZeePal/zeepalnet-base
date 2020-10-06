locals {
  terraform_docker_image = "hashicorp/terraform:${var.terraform_version}"
  terraform_env_vars = concat([
    "GOOGLE_PROJECT=${var.project_id}",
    "GOOGLE_REGION=${var.region}"
  ], var.extra_env_vars)
  docker_image_prefix = "gcr.io/$PROJECT_ID"
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
    artifacts {
      images = [
        "${local.docker_image_prefix}/git-verify:latest",
        "${local.docker_image_prefix}/terraform-with-gcloud-ssh:latest"
      ]
    }


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
      name = "${local.docker_image_prefix}/git-verify"
      args = [
        "verify-commit", "HEAD"
      ]
    }

    step {
      id       = "build git verify image"
      wait_for = ["git verify"] # TF & Docker Builds can run in parallel
      name     = "gcr.io/cloud-builders/docker"
      args = [
        "build",
        "-t", "${local.docker_image_prefix}/git-verify:latest",
        "--cache-from", "${local.docker_image_prefix}/git-verify:latest",
        "docker/git-verify/"
      ]
    }

    step {
      id       = "pull current gcloud ssh wrapper image"
      wait_for = ["git verify"] # TF & Docker Builds can run in parallel
      name     = "gcr.io/cloud-builders/docker"
      args = [
        "pull", "${local.docker_image_prefix}/terraform-with-gcloud-ssh:latest"
      ]
    }
    step {
      id       = "build gcloud ssh wrapper image"
      wait_for = ["pull current gcloud ssh wrapper image"]
      name     = "gcr.io/cloud-builders/docker"
      args = [
        "build",
        "-t", "${local.docker_image_prefix}/terraform-with-gcloud-ssh:latest",
        "--build-arg", "terraform_version=${var.terraform_version}",
        "--cache-from", "${local.docker_image_prefix}/terraform-with-gcloud-ssh:latest",
        "docker/terraform-with-gcloud-ssh/"
      ]
    }

    step {
      id       = "terraform init"
      wait_for = ["git verify"] # TF & Docker Builds can run in parallel
      name     = local.terraform_docker_image
      args = [
        "init",
        "-backend-config=bucket=${var.tfstate_bucket_name}",
        "-backend-config=prefix=$REPO_NAME"
      ]
      env = local.terraform_env_vars
    }
    step {
      id       = "terraform apply"
      wait_for = ["terraform init"]
      name     = local.terraform_docker_image
      args = [
        "apply",
        "-parallelism=1000",
        "-auto-approve"
      ]
      env = local.terraform_env_vars
    }
  }
}
