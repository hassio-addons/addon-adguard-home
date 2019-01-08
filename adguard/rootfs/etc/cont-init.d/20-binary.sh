#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: AdGuard Home
# Place executable into the data folder on startup.
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

cp -f /opt/AdGuardHome/AdGuardHome /data/AdGuardHome
