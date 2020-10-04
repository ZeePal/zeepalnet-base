# Top level GCP Pipeline for zeepalnet
This repo is intended to be the top/root level dependency for all future pipelines in zeepalnet gcp project.


# Bootstrapping
### Prerequisites
- An existing GCP Project
    - eg: zeepalnet
- `gcloud` CLI setup and authenticated locally
    - `gcloud init`
- Configure the GCP SDK to use your `gcloud` cli credentials
    - `gcloud auth application-default login`
- Terraform 0.13+ installed

## Example Process
```
# Configure your expected environment
export GOOGLE_REGION=australia-southeast1
export GOOGLE_PROJECT=zeepalnet
export TF_VAR_domain=zeepal.net
REPO_NAME="$(basename "$PWD")"

# Prep code for bootstrapping
mv _backend.tf _backend.tf.DISABLED

# Execute the Bootstrap
terraform init
terraform plan -parallelism=1000
terraform apply -parallelism=1000 -auto-approve

# Upload the local state to the new GCS bucket
mv _backend.tf.DISABLED _backend.tf
yes yes|terraform init -backend-config=bucket="${GOOGLE_PROJECT}-tfstate" -backend-config=prefix="$REPO_NAME"

# Build and Push the git-verify docker image
docker build -t gcr.io/$GOOGLE_PROJECT/git-verify docker/git-verify/
docker push gcr.io/$GOOGLE_PROJECT/git-verify
```
