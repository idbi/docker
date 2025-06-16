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

log "### [INFO] Starting Certbot issuance/renewal process..."

: "${DOMAIN:?Missing DOMAIN}"
: "${EMAIL:?Missing EMAIL}"

log "### [INFO] Parameters:"
log "    DOMAIN = $DOMAIN"
log "    EMAIL  = $EMAIL"

CERTBOT_CMD="certbot certonly \
  --dns-route53 \
  -d \"$DOMAIN\" -d \"*.$DOMAIN\" \
  --non-interactive --agree-tos \
  --email \"$EMAIL\" \
  --config-dir /etc/letsencrypt \
  --work-dir /var/lib/letsencrypt \
  --logs-dir /var/log/letsencrypt"

log "### [INFO] About to run Certbot command:"
log "    $CERTBOT_CMD"

# Actually run certbot (note: use eval to expand variables in CMD string for logging)
eval $CERTBOT_CMD

STATUS=$?

if [ $STATUS -eq 0 ]; then
  log "### [INFO] Certbot completed successfully for $DOMAIN."
else
  log "### [ERROR] Certbot failed with exit code $STATUS for $DOMAIN!"
  exit $STATUS
fi

# Show location of the produced certs
log "### [INFO] The certificates and keys should be located at: /etc/letsencrypt/live/$DOMAIN/"
ls -l /etc/letsencrypt/live/"$DOMAIN"

log "### [INFO] Certbot step completed."