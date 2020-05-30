FROM python:3.7-slim

ARG DO_ANSIBLE_INVENTORY_VERSION=1.0.0
ARG DOCTL_VERSION=1.43.0
ARG ANSIBLE_VERSION=2.9.7

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends curl openssh-client && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir ~/.ssh && \
    chmod -R 600 ~/.ssh

RUN curl -LO https://github.com/digitalocean/doctl/releases/download/v${DOCTL_VERSION}/doctl-${DOCTL_VERSION}-linux-amd64.tar.gz && \
    tar -xvf doctl-${DOCTL_VERSION}-linux-amd64.tar.gz && \
    mv doctl /usr/local/bin/doctl && \
    rm -f doctl-${DOCTL_VERSION}-linux-amd64.tar.gz

RUN curl -Ls https://github.com/do-community/do-ansible-inventory/releases/download/v${DO_ANSIBLE_INVENTORY_VERSION}/do-ansible-inventory_${DO_ANSIBLE_INVENTORY_VERSION}_linux_x86_64.tar.gz  | tar xvz -C /tmp && \
    mv /tmp/do-ansible-inventory /usr/local/bin

RUN pip install ansible==${ANSIBLE_VERSION}

ENTRYPOINT ["ansible"]
