FROM alpine:3.20

RUN apk update && \
  apk add --update \
    bash \
    easy-rsa \
    git \
    openssh-client \
    curl \
    ca-certificates \
    jq \
    python3 \
    py3-yaml \
    py3-ijson \
    py3-pip \
    libstdc++ \
    gpgme \
    git-crypt \
    && \
    rm -rf /var/cache/apk/*

RUN pip install --break-system-packages awscli
RUN adduser -h /backup -D backup

ENV KUBECTL_VERSION 1.27.0

RUN curl -SL https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o kubectl && chmod +x kubectl && \
    curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256" && \
    echo "$(cat kubectl.sha256) kubectl" | sha256sum -c || exit 10

ENV PATH="/:${PATH}"

COPY entrypoint.sh /
USER backup
ENTRYPOINT ["/entrypoint.sh"]
