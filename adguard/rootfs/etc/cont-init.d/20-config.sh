#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: AdGuard Home
# Handles configuration
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

readonly CONFIG="/data/adguard/AdGuardHome.yaml"
declare port

if ! hass.file_exists "${CONFIG}"; then
    mkdir -p /data/adguard
    cp /etc/adguard/AdGuardHome.yaml "${CONFIG}"
fi

port=$(hass.config.get "dns_port")

yq write --inplace "${CONFIG}" \
    'dns.port' "${port}" \
    || hass.die 'Failed updating AdGuardHome DNS port'

ln -s /data/adguard /opt/AdGuardHome/data
