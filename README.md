# IDBI Docker Monorepo

This repository is the home for all **IDBI’s containerized automation tools and infrastructure components**. It uses a monorepo approach: each project or utility is placed in its own subdirectory, with a dedicated Docker build context.

---

## Repository Structure

Each subdirectory under the repository root is a standalone Docker project:

```
idbi/docker/
├── <project-1>/
│   ├── Dockerfile
│   ├── entrypoint.sh
│   └── scripts/
│       └── ...
├── <project-2>/
│   ├── Dockerfile
│   └── ...
└── ...
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

## CI/CD: Automatic Multi-Project Builds

This repository is powered by CI that:
- Detects all subdirectories containing a `Dockerfile`
- Builds each as an independent Docker image
- Optionally pushes images to [GitHub Container Registry (GHCR)](https://ghcr.io) or other registries

When new Docker projects are added, they are picked up automatically on the next workflow run.

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