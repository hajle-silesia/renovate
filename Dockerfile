# Docker image customizing
# source: https://github.com/cloudposse/geodesic#customizing-your-docker-image

ARG GEODESIC_REPOSITORY=cloudposse/geodesic
ARG GEODESIC_TAG=3.3.0-debian

# renovate: datasource=github-releases depName=jdx/mise
ARG MISE_VERSION=v2024.9.0

FROM ${GEODESIC_REPOSITORY}:${GEODESIC_TAG}

ENV BANNER="local-dev"

ENV DOCKER_IMAGE="mtweeman/hajle-silesia_provisioning-ld"
ENV DOCKER_TAG="latest"

# Mise installation
# source: https://mise.jdx.dev/getting-started.html
ARG MISE_VERSION
ARG MISE_INSTALL_PATH="/usr/local/bin/mise"
ARG MISE_DATA_DIR="/usr/share/xdg_data_home/mise"
RUN curl https://mise.run | MISE_INSTALL_PATH="${MISE_INSTALL_PATH}" MISE_VERSION="${MISE_VERSION}" sh
#RUN echo "eval \"\$(${MISE_INSTALL_PATH} activate bash)\"" >> ~/.profile
ENV PATH="$PATH:${MISE_DATA_DIR}/shims"
# source: https://mise.jdx.dev/configuration.html#system-config-etc-mise-config-toml
COPY .mise.toml /etc/mise/config.toml
# source: https://mise.jdx.dev/cli/install.html
RUN mise install --yes
