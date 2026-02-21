# Start from latest Debian slim
FROM debian:12-slim

# Install SSH and rsync for deployments
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openssh-client \
    rsync \
    git \
    curl \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user for SSH key handling
RUN useradd -m -s /bin/bash deploy

# Set working directory
WORKDIR /app

# Use deploy user for security
USER deploy

# Default command
CMD ["/bin/bash"]
