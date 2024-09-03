# Docker image customizing
# source: https://github.com/cloudposse/geodesic#customizing-your-docker-image

ARG GEODESIC_REPOSITORY=cloudposse/geodesic
ARG GEODESIC_TAG=3.2.0-debian

# renovate: datasource=github-releases depName=cloudposse/atmos
ARG ATMOS_VERSION=1.88.0
# renovate: datasource=github-releases depName=hashicorp/terraform
ARG TERRAFORM_VERSION=1.9.5
ARG TFLINT_VERSION=0.53.0
# renovate: datasource=github-releases depName=cloudposse/packages
ARG TRIVY_VERSION=0.54.0
ARG CHECKOV_VERSION=3.2.238

FROM ${GEODESIC_REPOSITORY}:${GEODESIC_TAG}

ENV BANNER="local-dev"

ENV DOCKER_IMAGE="mtweeman/hajle-silesia_provisioning-ld"
ENV DOCKER_TAG="latest"

# Terraform repository installation (Geodesic ~> 3.0 doesn't support Terraform)
# sources:
# https://github.com/cloudposse/geodesic/blob/main/README.md
# https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg \
    software-properties-common
RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
RUN gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list

# Terraform installation
ARG TERRAFORM_VERSION
RUN apt-get update && apt-get install -y --allow-downgrades --no-install-recommends \
    terraform="${TERRAFORM_VERSION}-*"

# Atmos installation
ARG ATMOS_VERSION
RUN apt-get update && apt-get install -y --allow-downgrades --no-install-recommends \
    atmos="${ATMOS_VERSION}-*"

# TFLint installation
ARG TFLINT_VERSION
RUN apt-get update && apt-get install -y --allow-downgrades --no-install-recommends \
    tflint="${TFLINT_VERSION}-*"

# Trivy installation
ARG TRIVY_VERSION
RUN apt-get update && apt-get install -y --allow-downgrades --no-install-recommends \
    trivy="${TRIVY_VERSION}-*"

## Checkov installation
#ARG CHECKOV_VERSION
#RUN apt-get update && apt-get install -y --allow-downgrades \
#    checkov="${CHECKOV_VERSION}-*"
