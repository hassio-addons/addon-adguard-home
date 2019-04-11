#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: AdGuard Home
# Handles configuration
# ==============================================================================
readonly CONFIG="/data/adguard/AdGuardHome.yaml"
declare port

if ! bashio::fs.file_exists "${CONFIG}"; then
    mkdir -p /data/adguard
    cp /etc/adguard/AdGuardHome.yaml "${CONFIG}"
fi

port=$(bashio::addon.port "53/udp")
yq write --inplace "${CONFIG}" \
    'dns.port' "${port}" \
    || hass.die 'Failed updating AdGuardHome DNS port'

ln -s /data/adguard /opt/AdGuardHome/data
