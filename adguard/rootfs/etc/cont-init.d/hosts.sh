#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: AdGuard Home
# Adds client friendly names for IP addresses
# ==============================================================================
declare name
declare ip

for host in $(bashio::config 'hosts|keys'); do
    name=$(bashio::config "hosts[${host}].name")
    ip=$(bashio::config "hosts[${host}].ip")
    bashio::log.debug "Adding host: ${ip} matches ${name}"
    echo "${ip} ${name}" >> /etc/hosts
done
