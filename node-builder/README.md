# Node.js + OpenJDK 17 Docker Image

This project provides a Docker image based on the latest Node.js LTS version,
with OpenJDK 17 and `rsync` pre-installed.  
It can be used for full-stack applications that require both Node.js and Java.

---

## Features

- Node.js LTS, npm, and npx included
- OpenJDK 17 runtime (for running Java applications)
- Rsync for file sync/backup jobs
- Starts in `/app` working directory and launches `bash` by default

---

## Usage

### **Pull from GitHub Container Registry**

```sh
docker pull ghcr.io/idbi/docker-node-builder:latest
```

**Available tags:**
- `ghcr.io/idbi/docker-node-builder:latest` — Latest stable release
- `ghcr.io/idbi/docker-node-builder:X.Y.Z` — Specific version
- `ghcr.io/idbi/docker-node-builder:X` — Latest patch for major version

### **Build Locally**

```sh
docker build -t node-builder:latest .
```

### **Run an Interactive Shell**

```sh
docker run -it --rm nodejdk17-app
```

### **Use in your own Docker images (example)**

Extend in your own Dockerfile:

```dockerfile
FROM ghcr.io/<your-organization>/nodejdk17-app:latest
# ...add your application files and customizations...
```

### **Use as a CI/CD Build Runner**

This image is suitable for:

- Running Node.js or Java (JAR) CLI tools
- Building or testing Node.js backends calling Java-based tools
- Multi-language continuous integration jobs

---

## Customization

To use as a base for your Node app, uncomment and adapt in the Dockerfile:

```dockerfile
COPY package*.json ./
RUN npm install
COPY . .
```

---

*Maintained by the IDBI DevOps Team.*