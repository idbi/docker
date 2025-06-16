#!/bin/bash
#
# docker
# 01-renew.sh
# This file is part of docker.
# Copyright (c) 2025.
# Last modified at Mon, 16 Jun 2025 12:11:19 -0500 by nick.
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


log "### [INFO] Starting certificate renewal check..."

# Validate required variables
: "${VAULT_CERT_PATH:?Missing VAULT_CERT_PATH}"
: "${DOMAIN:?Missing DOMAIN}"

DAYS_THRESHOLD="${DAYS_THRESHOLD:-7}"
TMP_CERT="/tmp/checkcert_${DOMAIN}.pem"

log "### [INFO] Parameters:"
log "    DOMAIN           = $DOMAIN"
log "    VAULT_CERT_PATH  = $VAULT_CERT_PATH"
log "    DAYS_THRESHOLD   = $DAYS_THRESHOLD"

log "### [INFO] Attempting to fetch existing certificate from Vault at: ${VAULT_CERT_PATH}/${DOMAIN}"

CERT=$(vault kv get -field=fullchain "$VAULT_CERT_PATH/$DOMAIN" 2>/dev/null || true)
if [ -z "$CERT" ]; then
  log "### [WARN] No valid certificate found in Vault. Renewal REQUIRED."
  exit 0
fi

log "### [INFO] Certificate fetched from Vault. Writing temporary file for analysis."
echo "$CERT" > "$TMP_CERT"

log "### [INFO] Extracting certificate expiration date using OpenSSL..."
EXP_DATE=$(openssl x509 -enddate -noout -in "$TMP_CERT" | cut -d= -f2)
log "    Expiration date: $EXP_DATE"

EXP_EPOCH=$(date -d "$EXP_DATE" +%s)
NOW_EPOCH=$(date +%s)
DAYS_LEFT=$(( (EXP_EPOCH - NOW_EPOCH) / 86400 ))

log "### [INFO] Certificate expires in $DAYS_LEFT days."

if [ "$DAYS_LEFT" -le "$DAYS_THRESHOLD" ]; then
  log "### [INFO] $DAYS_LEFT days left is less than or equal to threshold of $DAYS_THRESHOLD. Renewal NEEDED!"
  exit 0  # 0 = Needs renew
else
  log "### [INFO] $DAYS_LEFT days left is greater than threshold of $DAYS_THRESHOLD. Renewal NOT required."
  exit 1  # 1 = No renew
fi