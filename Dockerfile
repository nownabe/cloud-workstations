FROM us-central1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss:latest
# debian bullseye

LABEL org.opencontainers.image.authors="Shawn Watanabe <nownabe@gmail.com>"
LABEL org.opencontainers.image.url="https://github.com/nownabe/cloud-workstations"
LABEL org.opencontainers.image.documentation="https://github.com/nownabe/cloud-workstations"
LABEL org.opencontainers.image.source="https://github.com/nownabe/cloud-workstations"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.title="Image for Cloud Workstations"
LABEL org.opencontainers.image.description="Image for Cloud Workstations"

ARG runuser="user"
ARG asdf_version="0.11.1"

ENV ASDF_VERSION=$asdf_version

ENV LANG=en_US.UTF-8

# For compatibility with GitHub Codespaces
ENV CODESPACES=true

COPY install_asdf.sh /opt/install_asdf.sh

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libyaml-dev \
    locales-all \
    zsh \
  && bash /opt/install_asdf.sh \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY ./assets/. /
