# Stage 1: Get Vault binary
FROM hashicorp/vault:1.19.3 AS vault-bin

# Stage 2: Start from a minimal base and add required utilities
FROM alpine:latest

RUN apk add --no-cache coreutils bash curl jq openssl certbot certbot-dns-route53

# Copy Vault binary from build stage
COPY --from=vault-bin /bin/vault /usr/local/bin/vault

# Set working directory
WORKDIR /work

# Copy entrypoint and scripts
COPY entrypoint.sh /work/entrypoint.sh
COPY scripts/* /work/scripts/

# Ensure all scripts are executable
RUN chmod +x /work/scripts/* /work/entrypoint.sh

# Set default entrypoint
ENTRYPOINT ["/work/entrypoint.sh"]