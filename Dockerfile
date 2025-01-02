FROM ghcr.io/getsops/sops:v3.9.3-alpine AS sops

FROM python:3.13.1-alpine
ARG UID=12563
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/home/ansible" \
    --uid "$UID" \
    ansible

RUN apk add openssh-client

COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

COPY --from=sops /usr/local/bin/sops /usr/bin/sops

USER ansible
WORKDIR /home/ansible

RUN ansible-galaxy collection install \
    ansible.netcommon \
    ansible.posix \
    ansible.utils \
    community.crypto \
    community.general \
    community.docker \
    community.sops \
    containers.podman
