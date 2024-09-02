# Docker image customizing
# source: https://github.com/cloudposse/geodesic#customizing-your-docker-image
# renovate: datasource=docker depName=cloudposse/geodesic versioning=docker
ARG GEODESIC_VERSION=3.1.0
ARG GEODESIC_OS=debian

ARG ATMOS_VERSION=1.70.0
ARG TERRAFORM_VERSION=1.9.4
ARG TFLINT_VERSION=0.53.0
ARG TRIVY_VERSION=0.54.1
ARG CHECKOV_VERSION=3.2.238

FROM cloudposse/geodesic:$GEODESIC_VERSION-$GEODESIC_OS

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
