FROM ubuntu:20.04

RUN apt-get -y update && \
    apt-get -y install \
      git \
      gnupg2 \
    && rm -rf /var/lib/apt/lists/*

COPY git-gpg /usr/local/bin/
RUN git config --system gpg.program git-gpg

COPY signing_key.asc /tmp/signing_key.asc
RUN gpg --no-default-keyring --keyring=/etc/signing_keys.gpg \
      --import /tmp/signing_key.asc && \
    rm -f /tmp/signing_key.asc

ENTRYPOINT ["/usr/bin/git"]
