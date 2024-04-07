ARG BUILD_FROM=ghcr.io/hassio-addons/base:15.0.7
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

ARG BUILD_ARCH=amd64

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
ARG ADGUARD_HOME_VERSION="v0.107.48"
# hadolint ignore=DL3003,SC2155
RUN \
    apk add --no-cache \
        nginx=1.24.0-r15 \
        yq=4.35.2-r3 \
    \
    && if [[ "${BUILD_ARCH}" = "aarch64" ]]; then ARCH="arm64"; fi \
    && if [[ "${BUILD_ARCH}" = "amd64" ]]; then ARCH="amd64"; fi \
    && if [[ "${BUILD_ARCH}" = "armv7" ]]; then ARCH="armv7"; fi \
    \
    && curl -L -s \
        "https://github.com/AdguardTeam/AdGuardHome/releases/download/${ADGUARD_HOME_VERSION}/AdGuardHome_linux_${ARCH}.tar.gz" \
        | tar zxvf - -C /opt/ \
    \
    && chmod a+x /opt/AdGuardHome/AdGuardHome \
    \
    && rm -fr \
        /etc/nginx \
        /tmp/*

 # Copy root filesystem
COPY rootfs /

# Health check
HEALTHCHECK CMD curl --fail http://127.0.0.1:45158 || exit 1

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
