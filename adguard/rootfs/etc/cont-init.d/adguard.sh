#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: AdGuard Home
# Handles configuration
# ==============================================================================
readonly CONFIG="/data/adguard/AdGuardHome.yaml"
declare port
declare host

if ! bashio::fs.file_exists "${CONFIG}"; then
    mkdir -p /data/adguard
    cp /etc/adguard/AdGuardHome.yaml "${CONFIG}"
fi

port=$(bashio::addon.port "53/udp")
yq write --inplace "${CONFIG}" \
    'dns.port' "${port}" \
    || hass.exit.nok 'Failed updating AdGuardHome DNS port'

host=$(bashio::network.ipv4_address)
yq write --inplace "${CONFIG}" \
    'dns.bind_host' "${host}" \
    || hass.exit.nok 'Failed updating AdGuardHome host'
