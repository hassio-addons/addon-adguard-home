#!/usr/bin/with-contenv bashio
# shellcheck disable=SC2207
# ==============================================================================
# Home Assistant Community Add-on: AdGuard Home
# Handles configuration
# ==============================================================================
readonly CONFIG="/data/adguard/AdGuardHome.yaml"
declare port
declare -a hosts

if ! bashio::fs.file_exists "${CONFIG}"; then
    mkdir -p /data/adguard
    cp /etc/adguard/AdGuardHome.yaml "${CONFIG}"
fi

port=$(bashio::addon.port "53/udp")
yq write --inplace "${CONFIG}" \
    dns.port "${port}" \
    || bashio::exit.nok 'Failed updating AdGuardHome DNS port'

# Clean up old interface bind formats
yq delete --inplace "${CONFIG}" dns.bind_host
yq delete --inplace "${CONFIG}" dns.bind_hosts

hosts+=($(bashio::network.ipv4_address))
hosts+=($(bashio::network.ipv6_address))
hosts+=($(bashio::addon.ip_address))
for host in "${hosts[@]}"; do
    bashio::log.info "Adding ${host}"
    yq write --inplace "${CONFIG}" \
        dns.bind_hosts[+] "${host%/*}" \
        || bashio::exit.nok 'Failed updating AdGuardHome host'
done
