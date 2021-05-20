#!/usr/bin/with-contenv bashio
# shellcheck disable=SC2207
# ==============================================================================
# Home Assistant Community Add-on: AdGuard Home
# Handles configuration
# ==============================================================================
readonly CONFIG="/data/adguard/AdGuardHome.yaml"
declare port
declare schema_version
declare -a hosts
declare addresses

if ! bashio::fs.file_exists "${CONFIG}"; then
    mkdir -p /data/adguard
    cp /etc/adguard/AdGuardHome.yaml "${CONFIG}"
fi

port=$(bashio::addon.port "53/udp")
yq write --inplace "${CONFIG}" \
    dns.port "${port}" \
    || bashio::exit.nok 'Failed updating AdGuardHome DNS port'


# Bump schema version in case this is an upgrade path
schema_version=$(yq read "${CONFIG}" schema_version)
if bashio::var.has_value "${schema_version}"; then
    if [[ "${schema_version}" -eq 7 ]]; then
        # Clean up old interface bind formats
        yq delete --inplace "${CONFIG}" dns.bind_host
        yq write --inplace "${CONFIG}" schema_version 8
    fi

    # Warn if this is an upgrade from below schema version 7, skip further process
    if [[ "${schema_version}" -lt 7 ]]; then
        bashio::warning
        bashio::warning "AdGuard Home needs to update its configuration schema"
        bashio::warning "you might need to restart he add-on once more to complete"
        bashio::warning "the upgrade process."
        bashio::warning
        bashio::exit.ok
    fi
fi

# Get IPv4 address
addresses=$(bashio::network.ipv4_address)
hosts+=("${addresses%/*}")

# Get IPv6 address
addresses=$(bashio::network.ipv6_address)
hosts+=("${addresses%/*}")

# Get "hassio" network interface
addresses=$(bashio::addon.ip_address)
hosts+=("${addresses%/*}")

# Add interface to bind to, to AdGuard Home
yq delete --inplace "${CONFIG}" dns.bind_hosts
for host in "${hosts[@]}"; do
    if bashio::var.has_value "${host}"; then
        bashio::log.info "Adding ${host}"
        yq write --inplace "${CONFIG}" \
            dns.bind_hosts[+] "${host%/*}" \
            || bashio::exit.nok 'Failed updating AdGuardHome host'
    fi
done
