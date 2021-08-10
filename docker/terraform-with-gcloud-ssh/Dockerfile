FROM gcr.io/cloud-builders/gcloud

COPY ssh_wrapper /usr/local/bin/ssh

COPY hashicorp.asc /tmp/
ARG terraform_version=1.0.4
RUN cd /tmp && \
    gpg --no-default-keyring --keyring=hashicorp.gpg --import hashicorp.asc && \
    curl -o terraform_${terraform_version}_linux_amd64.zip https://releases.hashicorp.com/terraform/$terraform_version/terraform_${terraform_version}_linux_amd64.zip && \
    curl -o terraform_${terraform_version}_SHA256SUMS.sig https://releases.hashicorp.com/terraform/$terraform_version/terraform_${terraform_version}_SHA256SUMS.sig && \
    curl -o terraform_${terraform_version}_SHA256SUMS https://releases.hashicorp.com/terraform/$terraform_version/terraform_${terraform_version}_SHA256SUMS && \
    gpg --no-default-keyring --keyring=hashicorp.gpg --verify terraform_${terraform_version}_SHA256SUMS.sig terraform_${terraform_version}_SHA256SUMS && \
    sha256sum -c --ignore-missing terraform_${terraform_version}_SHA256SUMS && \
    apt-get -y update && \
    apt-get -y --no-install-recommends install unzip && \
    unzip -j terraform_${terraform_version}_linux_amd64.zip terraform -d /usr/local/bin/ && \
    apt-get -y remove --purge unzip && \
    rm -rf hashicorp.* terraform_* /var/lib/apt/lists/*

ENTRYPOINT ["/usr/local/bin/terraform"]
