# SSH Agent

A lightweight Docker image for SSH-based deployments using rsync.

## Features

- OpenSSH client for secure remote access
- rsync for efficient file synchronization
- Git support for version control operations
- curl for HTTP requests
- Non-root `deploy` user for security

## Usage

### Basic deployment with rsync

```bash
docker run --rm \
  -v ~/.ssh:/home/deploy/.ssh:ro \
  -v /local/path:/app \
  ssh-agent rsync -avz -e ssh /app/ user@remote:/remote/path/
```

### With SSH key from environment

```bash
docker run --rm \
  -e SSH_KEY="$(cat ~/.ssh/id_rsa)" \
  ssh-agent bash -c 'echo "$SSH_KEY" > ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa && rsync ...'
```

## Notes

The image uses a non-root `deploy` user. Ensure proper SSH key permissions when mounting or injecting keys.
