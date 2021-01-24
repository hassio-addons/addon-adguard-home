#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: AdGuard Home
# Configures NGINX for use with the AdGuard Home server
# ==============================================================================
declare adguard_port=45158
declare adguard_protocol=http
declare tls_port

# Figure out port settings from AdGuard
if bashio::var.true "$(yq read /data/adguard/AdGuardHome.yaml tls.enabled)";
then
    tls_port=$(yq read /data/adguard/AdGuardHome.yaml tls.port_https)
    if bashio::var.has_value "${tls_port}" && [[ "${tls_port}" -ne 0 ]]; then
        adguard_port="${tls_port}"
        adguard_protocol=https
    fi
fi

# Generate upstream configuration
bashio::var.json \
    port "^${adguard_port}" \
    | tempio \
        -template /etc/nginx/templates/upstream.gtpl \
        -out /etc/nginx/includes/upstream.conf

# Generate Ingress configuration
bashio::var.json \
    interface "$(bashio::addon.ip_address)" \
    port "^$(bashio::addon.ingress_port)" \
    protocol "${adguard_protocol}" \
    | tempio \
        -template /etc/nginx/templates/ingress.gtpl \
        -out /etc/nginx/servers/ingress.conf

# Generate direct access configuration, if enabled.
if bashio::var.has_value "$(bashio::addon.port 80)"; then
    bashio::config.require.ssl
    bashio::var.json \
        certfile "$(bashio::config 'certfile')" \
        keyfile "$(bashio::config 'keyfile')" \
        leave_front_door_open "^$(bashio::config 'leave_front_door_open')" \
        port "^$(bashio::addon.port 80)" \
        protocol "${adguard_protocol}" \
        ssl "^$(bashio::config 'ssl')" \
        | tempio \
            -template /etc/nginx/templates/direct.gtpl \
            -out /etc/nginx/servers/direct.conf
fi
