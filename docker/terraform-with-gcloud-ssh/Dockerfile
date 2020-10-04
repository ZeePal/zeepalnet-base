ARG terraform_docker_image=hashicorp/terraform:0.13.3
FROM $terraform_docker_image

FROM gcr.io/cloud-builders/gcloud
COPY --from=0 /bin/terraform /bin/terraform
COPY ssh_wrapper /usr/local/bin/ssh
ENTRYPOINT ["/bin/terraform"]
