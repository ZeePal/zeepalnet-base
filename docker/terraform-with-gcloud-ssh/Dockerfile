FROM gcr.io/cloud-builders/gcloud

COPY ssh_wrapper /usr/local/bin/ssh

COPY hashicorp.asc /tmp/
RUN cd /tmp && \
    gpg --no-default-keyring --keyring=hashicorp.gpg --import hashicorp.asc && \
    curl -o terraform_0.13.3_linux_amd64.zip https://releases.hashicorp.com/terraform/0.13.3/terraform_0.13.3_linux_amd64.zip && \
    curl -o terraform_0.13.3_SHA256SUMS.sig https://releases.hashicorp.com/terraform/0.13.3/terraform_0.13.3_SHA256SUMS.sig && \
    curl -o terraform_0.13.3_SHA256SUMS https://releases.hashicorp.com/terraform/0.13.3/terraform_0.13.3_SHA256SUMS && \
    gpg --no-default-keyring --keyring=hashicorp.gpg --verify terraform_0.13.3_SHA256SUMS.sig terraform_0.13.3_SHA256SUMS && \
    sha256sum -c --ignore-missing terraform_0.13.3_SHA256SUMS && \
    apt-get -y update && \
    apt-get -y --no-install-recommends install unzip && \
    unzip -j terraform_0.13.3_linux_amd64.zip terraform -d /usr/local/bin/ && \
    apt-get -y remove --purge unzip && \
    rm -rf hashicorp.* terraform_* /var/lib/apt/lists/*

ENTRYPOINT ["/usr/local/bin/terraform"]
