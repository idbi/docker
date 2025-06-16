# Certbot Renewal Automation

This project provides a containerized solution for **automated TLS/SSL certificate renewal** using [Certbot](https://certbot.eff.org/) with DNS validation (typically via AWS Route53) and secure upload of certificates to a [HashiCorp Vault](https://www.vaultproject.io/) server.  
It is designed for use as a Kubernetes Job, CronJob, or a standalone automation task.

---

## Features

- **Automated certificate renewals** based on custom expiry thresholds.
- Uses **DNS-01 challenge** (Route53 plugin) for wildcard and domain certificates.
- Uploads new certificates and private keys securely to a configurable Vault path.
- Modular Bash scripting — each phase (check, renew, upload) is a separate script.
- Container- and cloud-native: easy to integrate with Kubernetes, CI/CD, or as a one-shot script.

---

## Directory Structure

```
certbot-renewal/
├── Dockerfile
├── entrypoint.sh
└── scripts/
    ├── 00-check.sh      # Check if current certificate in Vault needs renewal
    ├── 01-renew.sh      # Runs Certbot to obtain/renew certificate
    └── 02-upload.sh     # Uploads renewed certificate and key to Vault
```

---

## Usage

### 1. **Build the Docker Image**

```sh
docker build -t certbot-renewal:latest certbot-renewal/
```

### 2. **Run the Container**

Prepare your environment variables and credentials. Example:

```sh
docker run --rm \
  -e DOMAIN="example.com" \
  -e EMAIL="admin@example.com" \
  -e VAULT_CERT_PATH="myapp/certificates" \
  -e VAULT_TOKEN="..." \
  -e AWS_ACCESS_KEY_ID="..." \
  -e AWS_SECRET_ACCESS_KEY="..." \
  certbot-renewal:latest
```

**Required environment variables:**
- `DOMAIN` — The primary domain (wildcard supported).
- `EMAIL` — Email for Let's Encrypt notifications.
- `VAULT_CERT_PATH` — Base path in Vault to store the certificate.
- `VAULT_TOKEN` — Token with permissions to write the target path in Vault.
- `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` — Credentials to update Route53 records for DNS-01 validation.

**Optional environment variables:**
- `DAYS_THRESHOLD` — Number of days before certificate expiry to trigger renewal (default: 30).

---

## Workflow

1. `00-check.sh`:  
   Checks the current certificate in Vault. Determines whether renewal is needed based on expiry threshold.
2. `01-renew.sh`:  
   If renewal is needed, obtains a new certificate from Let's Encrypt using certbot and DNS (Route53) validation.
3. `02-upload.sh`:  
   Uploads the renewed certificate and private key to the chosen Vault path.

---

## Typical Kubernetes Usage (CronJob Skeleton)

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: certbot-renewal
spec:
  schedule: "0 0 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
            - name: certbot-renewal
              image: ghcr.io/yourorg/certbot-renewal:latest
              env:
                - name: DOMAIN
                  value: "example.com"
                - name: EMAIL
                  value: "admin@example.com"
                - name: VAULT_CERT_PATH
                  value: "myapp/certificates"
                - name: VAULT_TOKEN
                  valueFrom:
                    secretKeyRef:
                      name: vault-credentials
                      key: vault-token
                - name: AWS_ACCESS_KEY_ID
                  valueFrom:
                    secretKeyRef:
                      name: aws-creds
                      key: aws-access-key-id
                - name: AWS_SECRET_ACCESS_KEY
                  valueFrom:
                    secretKeyRef:
                      name: aws-creds
                      key: aws-secret-access-key
```

---

## Security Notes

- Ensure Vault and AWS credentials are injected via Kubernetes secrets, not hardcoded.
- The container runs each operation step-by-step and only performs renewal/upload when needed.
- Regularly rotate your Vault tokens and AWS keys.

---

## Extending

- To use a different DNS provider: adjust certbot arguments and install the required plugin.
- For notification/webhook on renewal: hook into the end of `02-upload.sh`.
- For monitoring: emit logs to a centralized system, or use sidecars (e.g., Promtail or Otel Collector).

---

## Troubleshooting

- Check logs from `entrypoint.sh` and individual scripts for step-by-step output.
- Ensure correct permissions in Vault (write access) and AWS Route53 (DNS record management).
- Validate your environment variables and secrets for typos or missing entries.


---

For questions, improvements, or bug reports, please contact the IDBI DevOps team.