ARG BUILD_FROM=hassioaddons/base:2.3.0
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
ARG BUILD_ARCH=amd64
# hadolint ignore=DL3003
RUN \
    apk add --no-cache \
        lua-resty-http=0.12-r1 \
        nginx-mod-http-lua=1.14.2-r0 \
        nginx=1.14.2-r0 \
    \
    && if [[ "${BUILD_ARCH}" = "aarch64" ]]; then ARCH="arm64"; fi \
    && if [[ "${BUILD_ARCH}" = "amd64" ]]; then ARCH="amd64"; fi \
    && if [[ "${BUILD_ARCH}" = "armhf" ]]; then ARCH="arm"; fi \
    && if [[ "${BUILD_ARCH}" = "i386" ]]; then ARCH="386"; fi \
    \
    && mkdir /opt \
    && curl -L -s \
        "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.92-hotfix1/AdGuardHome_v0.92-hotfix1_linux_${ARCH}.tar.gz" \
        | tar zxvf - -C /opt/ \
    && chmod a+x /opt/AdGuardHome/AdGuardHome

 # Copy root filesystem
COPY rootfs /

# Build arugments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="AdGuard Home" \
    io.hass.description="Network-wide ads & trackers blocking DNS server" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.label-schema.description="Network-wide ads & trackers blocking DNS server" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Adguard Home" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://community.home-assistant.io/?u=frenck" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-adguard-home/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-adguard-home" \
    org.label-schema.vendor="Community Hass.io Add-ons"
