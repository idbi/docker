# IDBI Docker Monorepo

This repository is the home for all **IDBI’s containerized automation tools and infrastructure components**. It uses a monorepo approach: each project or utility is placed in its own subdirectory, with a dedicated Docker build context.

---

## Components

### **php-builder**
A PHP 8.3 + Composer Docker image with comprehensive extensions for modern PHP applications. Includes support for databases (PDO MySQL, PostgreSQL), image processing (GD), and text processing (mbstring, intl, XML).

### **node-builder**
A Node.js LTS + OpenJDK 17 Docker image for full-stack applications requiring both Node.js and Java. Includes rsync for file synchronization tasks. Suitable for multi-language CI/CD workflows.

### **certbot-renewal**
An automated TLS/SSL certificate renewal solution using Certbot with DNS-01 validation (AWS Route53) and secure upload to HashiCorp Vault. Designed for Kubernetes CronJobs and standalone automation.

---

## Repository Structure

```
docker/
├── php-builder/
│   ├── Dockerfile
│   ├── README.md
│   └── CHANGELOG.md
├── node-builder/
│   ├── Dockerfile
│   ├── README.md
│   └── CHANGELOG.md
├── certbot-renewal/
│   ├── Dockerfile
│   ├── entrypoint.sh
│   ├── README.md
│   └── scripts/
├── release.json
└── README.md
```

---

## Philosophy

- **Component Independence:**  
  Every project is self-contained and portable as a Docker build context.

- **Unified Automation:**  
  A common CI/CD workflow discovers, builds, and (optionally) publishes every project’s image.

- **Extensibility:**  
  To add a tool, simply create a new directory with a `Dockerfile` and any supporting scripts/configuration.

---

## Usage Example

```sh
# Build any project
cd <project-directory>
docker build -t <project-name>:latest .

# Run, passing required configuration via environment variables as needed
docker run --rm -e VAR1=value1 -e VAR2=value2 <project-name>:latest
```

_Refer to individual project documentation or code for runtime requirements and configuration options._

---

## Deployment & Versioning

This repository uses [Release Please](https://github.com/googleapis/release-please) to automate versioning and Docker image releases.

### How It Works

1. **Automated Release PRs**: Release Please monitors commits and automatically creates a pull request when changes are detected.
2. **Semantic Versioning**: Each component follows semantic versioning (Major.Minor.Patch).
3. **Component Tags**: Images are tagged with both version and component name (e.g., `v1.2.3-php-builder`).
4. **Single Release PR**: All changed components are included in a single pull request for review.
5. **Merged Changelog**: Merging the release PR automatically publishes new image versions.

### Image Naming

Images are published to [GitHub Container Registry (GHCR)](https://ghcr.io) with the following pattern:
```
ghcr.io/idbi/<component>:v<version>-<component>
```

Examples:
- `ghcr.io/idbi/php-builder:v1.0.0-php-builder`
- `ghcr.io/idbi/node-builder:v1.0.0-node-builder`
- `ghcr.io/idbi/certbot-renewal:v1.0.0-certbot-renewal`

### Triggering a Release

Simply merge your changes to the main branch. Release Please will automatically:
1. Detect changes
2. Create a release PR with updated versions
3. Build and publish Docker images when the release PR is merged

---

## How to Add a New Project

1. Create a new subdirectory and place a `Dockerfile` and supporting scripts/config there.
2. (Optionally) Add a `README.md` with usage notes.
3. The CI system will build your project automatically.

---

## Contributing

- Suggestions, bugfixes, and new tools are welcome via pull requests or issues.
- Please use meaningful, unique directory names for each new project.


---

**Contact:**  
IDBI DevOps Team · [devops@idbi.pe](mailto:devops@idbi.pe)