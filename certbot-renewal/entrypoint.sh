#!/bin/bash
#
# docker
# entrypoint.sh
# This file is part of docker.
# Copyright (c) 2025.
# Last modified at Mon, 16 Jun 2025 12:19:22 -0500 by nick.
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

log() {
  # Usage: log "message"
  local msg="$1"
  local timestamp
  timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  # Print to stdout and append to log file
  command echo "$timestamp $msg" | tee -a "/var/log/letsencrypt/shell.log"
}

export -f log

log "### [INFO] Entrypoint script started."

# Check that all critical environment variables are set
REQUIRED_VARS=("VAULT_CERT_PATH" "DOMAIN" "EMAIL")
MISSING_VARS=0
for VAR in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!VAR}" ]; then
    log "### [ERROR] Required environment variable $VAR is not set."
    MISSING_VARS=1
  fi
done
if [ "$MISSING_VARS" -ne 0 ]; then
  log "### [FATAL] One or more required variables are missing. Aborting."
  exit 3
fi

# Run certificate check - if renewal is needed, the script exits 0; else exits 1
log "### [INFO] --- Phase 1: Renewal check ---"
./scripts/00-check.sh
CHECK_RENEW_STATUS=$?
if [ $CHECK_RENEW_STATUS -ne 0 ]; then
  log "### [INFO] Certificate is still valid, renewal NOT required. Exiting process."
  exit 0
fi

# If renewal is needed, run Certbot
log "### [INFO] --- Phase 2: Run Certbot issuance/renewal ---"
./scripts/01-renew.sh
CERTBOT_STATUS=$?
if [ $CERTBOT_STATUS -ne 0 ]; then
  log "### [FATAL] Certbot phase failed with status $CERTBOT_STATUS. Aborting."
  exit $CERTBOT_STATUS
fi

# Upload to Vault
log "### [INFO] --- Phase 3: Upload certificate/key to Vault ---"
./scripts/02-upload.sh
UPLOAD_STATUS=$?
if [ $UPLOAD_STATUS -ne 0 ]; then
  log "### [FATAL] Upload to Vault phase failed with status $UPLOAD_STATUS. Aborting."
  exit $UPLOAD_STATUS
fi

log "### [INFO] Entrypoint completed successfully. All steps finished."