#
# docker
# 02-upload.sh
# This file is part of docker.
# Copyright (c) 2025.
# Last modified at Mon, 16 Jun 2025 12:17:47 -0500 by nick.
#
# DISCLAIMER: This software is provided "as is" without warranty of any kind, either expressed or implied. The entire
# risk as to the quality and performance of the software is with you. In no event will the author be liable for any
# damages, including any general, special, incidental, or consequential damages arising out of the use or inability
# to use the software (that includes, but not limited to, loss of data, data being rendered inaccurate, or losses
# sustained by you or third parties, or a failure of the software to operate with any other programs), even if the
# author has been advised of the possibility of such damages.
# If a license file is provided with this software, all use of this software is governed by the terms and conditions
# set forth in that license file. If no license file is provided, no rights are granted to use, modify, distribute,
# or otherwise exploit this software.
#

set -e

log "### [INFO] Starting Vault upload step..."

# Required variables
: "${VAULT_CERT_PATH:?Missing VAULT_CERT_PATH}"
: "${DOMAIN:?Missing DOMAIN}"

CERTFILE="/etc/letsencrypt/live/$DOMAIN/fullchain.pem"
KEYFILE="/etc/letsencrypt/live/$DOMAIN/privkey.pem"

log "### [INFO] Parameters:"
log "    DOMAIN           = $DOMAIN"
log "    VAULT_CERT_PATH  = $VAULT_CERT_PATH"
log "    CERTFILE         = $CERTFILE"
log "    KEYFILE          = $KEYFILE"

if [ ! -f "$CERTFILE" ]; then
  log "### [ERROR] Certificate file not found at $CERTFILE"
  exit 2
fi

if [ ! -f "$KEYFILE" ]; then
  log "### [ERROR] Private key file not found at $KEYFILE"
  exit 2
fi

log "### [INFO] Both certificate and key found. Preparing to upload to Vault..."

vault kv put "$VAULT_CERT_PATH/$DOMAIN" \
    fullchain="$(cat "$CERTFILE")" \
    privkey="$(cat "$KEYFILE")"

VAULT_STATUS=$?
if [ $VAULT_STATUS -eq 0 ]; then
  log "### [INFO] Certificate and key uploaded to Vault successfully at $VAULT_CERT_PATH/$DOMAIN"
else
  log "### [ERROR] Vault upload failed with exit code $VAULT_STATUS"
  exit $VAULT_STATUS
fi

log "### [INFO] Vault upload step completed."