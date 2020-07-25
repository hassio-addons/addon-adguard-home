ARG BUILD_FROM=hassioaddons/base:8.0.1
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Copy yq
ARG BUILD_ARCH=amd64
COPY bin/yq_${BUILD_ARCH} /usr/bin/yq

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
# hadolint ignore=DL3003, SC2155
RUN \
    VERSION="v0.103.3" \
    \
    && apk add --no-cache --virtual .build-dependencies \
        nodejs=12.17.0-r0 \
        npm=12.17.0-r0 \
        build-base=0.5-r2 \
        git=2.26.2-r0 \
    \
    && apk add --no-cache \
        go@edge=1.14.6-r0 \
        lua-resty-http=0.15-r0 \
        nginx-mod-http-lua=1.18.0-r0 \
        nginx=1.18.0-r0 \
    \
    && git clone --branch "${VERSION}" --depth=1 \
        "https://github.com/AdguardTeam/AdGuardHome" /tmp/adguard \
    \
    && cd /tmp/adguard \
    && npm --prefix client ci \
    && npm --prefix client run build-prod \
    \
    && export \
        CGO_ENABLED=0 \
        COROOT_BOOTSTRAP="$(go env GOROOT)" \
        GO111MODULE="on" \
        GOARCH"$(go env GOARCH)" \
        GOOS="$(go env GOOS)" \
        GOPATH="$(go env GOPATH)" \
        PATH="/usr/local/go/bin:$(go env GOPATH)/bin:$PATH" \
        GOPROXY="https://goproxy.io" \
    \
    && if [[ "${BUILD_ARCH}" = "armhf" ]]; then export GOARM="6"; fi \
    && if [[ "${BUILD_ARCH}" = "armv7" ]]; then export GOARM="7"; fi \
    && if [[ "${BUILD_ARCH}" = "i386" ]]; then export GO386="387"; fi \
    \
    && go mod download \
    && go generate ./... \
    && go build \
        -ldflags="-s -w -X main.version=${VERSION#v} -X main.channel=release -X main.goarm=${GOARM}" \
    \
    && mkdir -p /opt/AdGuardHome \
    && mv AdGuardHome /opt/AdGuardHome/AdGuardHome \
    \
    && apk del --no-cache --purge \
        .build-dependencies \
        go \
    \
    && rm -fr \
        /etc/nginx \
        /root/.cache \
        /root/.config \
        /root/.npm \
        /root/go \
        /tmp/* \
        /usr/local/go

 # Copy root filesystem
COPY rootfs /

# Build arguments
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
    org.opencontainers.image.title="AdGuard Home" \
    org.opencontainers.image.description="Network-wide ads & trackers blocking DNS server" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/hassio-addons/addon-adguard-home" \
    org.opencontainers.image.documentation="https://github.com/hassio-addons/addon-adguard-home/blob/master/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
