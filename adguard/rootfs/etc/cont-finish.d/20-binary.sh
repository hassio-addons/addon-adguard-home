#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: AdGuard Home
# Remove executable from the data folder on shutdown.
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

rm -f /data/AdGuardHome
