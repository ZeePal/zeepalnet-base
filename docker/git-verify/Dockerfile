FROM alpine:latest

RUN apk add --no-cache git gnupg

COPY git-gpg signing_key.asc /usr/local/bin/
RUN git config --system gpg.program git-gpg && \
    gpg --no-default-keyring --keyring=/etc/signing_keys.gpg \
      --import /usr/local/bin/signing_key.asc && \
    rm -f /usr/local/bin/signing_key.asc

ENTRYPOINT ["/usr/bin/git"]
