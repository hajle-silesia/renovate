# Docker image customizing
# source: https://github.com/cloudposse/geodesic#customizing-your-docker-image

ARG GEODESIC_REPOSITORY=cloudposse/geodesic
ARG GEODESIC_TAG=3.2.0-debian

FROM ${GEODESIC_REPOSITORY}:${GEODESIC_TAG}

ENV BANNER="local-dev"

ENV DOCKER_IMAGE="mtweeman/hajle-silesia_provisioning-ld"
ENV DOCKER_TAG="latest"

# MISE TAKE TWO
SHELL ["/bin/bash", "-c"]
RUN curl https://mise.run | MISE_INSTALL_PATH=/usr/local/bin/mise MISE_VERSION=v2024.5.17 sh
RUN echo 'eval "$(/usr/local/bin/mise activate bash)"' >> ~/.profile
COPY .mise.toml /etc/mise/config.toml
RUN mise install -y
SHELL ["/bin/bash", "-l", "-c"]
