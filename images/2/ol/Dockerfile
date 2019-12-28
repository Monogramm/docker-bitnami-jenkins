FROM bitnami/jenkins:2.204.1-ol-7-r8

ARG DOCKER_CLIENT="docker-18.09.9.tgz"

# Install plugins and Docker from official repo
RUN set -ex; \
    /install-plugins.sh matrix-auth authorize-project ldap git github gitlab artifactory nexus-jenkins sonar; \
    cd /tmp/; \
    curl -sSL -O https://download.docker.com/linux/static/stable/x86_64/${DOCKER_CLIENT}; \
    tar zxf ${DOCKER_CLIENT}; \
    mkdir -p /usr/local/bin; \
    mv ./docker/docker /usr/local/bin; \
    chmod +x /usr/local/bin/docker; \
    rm -rf /tmp/*

# Arguments to label built container
ARG TAG
ARG VCS_REF
ARG BUILD_DATE
ARG VERSION=2.204.1

# Container labels (http://label-schema.org/)
# Container annotations (https://github.com/opencontainers/image-spec)
LABEL maintainer="Monogramm maintainers <opensource at monogramm dot io>" \
      product="Bitnami Jenkins" \
      version=$VERSION \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/Monogramm/docker-bitnami-jenkins" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Bitnami Jenkins" \
      org.label-schema.description="Custom Bitnami Docker Image for Jenkins." \
      org.label-schema.url="https://jenkins.io/" \
      org.label-schema.vendor="Jenkins" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0" \
      org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source="https://github.com/Monogramm/docker-bitnami-jenkins" \
      org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.title="Bitnami Jenkins" \
      org.opencontainers.image.description="Custom Bitnami Docker Image for Jenkins." \
      org.opencontainers.image.url="https://jenkins.io/" \
      org.opencontainers.image.vendor="Jenkins" \
      org.opencontainers.image.version=$VERSION \
      org.opencontainers.image.authors="Monogramm maintainers <opensource at monogramm dot io>"
