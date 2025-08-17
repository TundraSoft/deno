# 🦕 TundraSoft Deno Runtime Image

A lightweight, secure Deno runtime image built on Alpine Linux with S6 overlay, comprehensive permissions management, and developer-friendly utilities.

[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/TundraSoft/deno/build-docker.yml?event=push&logo=github&label=build)](https://github.com/TundraSoft/deno/actions/workflows/build-docker.yml)
[![Security Scan](https://img.shields.io/github/actions/workflow/status/TundraSoft/deno/security-scan.yml?logo=adguard&label=security)](https://github.com/TundraSoft/deno/actions/workflows/security-scan.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/tundrasoft/deno.svg?logo=docker)](https://hub.docker.com/r/tundrasoft/deno)
[![License](https://img.shields.io/github/license/TundraSoft/deno.svg)](https://github.com/TundraSoft/deno/blob/main/LICENSE)

---

## 📋 Table of Contents

- [🚀 Quick Start](#-quick-start)
- [🏷️ Available Tags](#️-available-tags)
- [✨ Features](#-features)
- [📖 Usage](#-usage)
  - [Basic Usage](#basic-usage)
  - [Environment Variables](#environment-variables)
  - [Permission Flags](#permission-flags)
  - [Volumes](#volumes)
- [⚙️ Service Management](#️-service-management)
- [🔧 Building](#-building)
- [🔒 Security](#-security)
- [📚 Components](#-components)
- [🤝 Contributing](#-contributing)

---

## 🚀 Quick Start

### 📦 Available Registries

This image is available on multiple registries:

- **Docker Hub**: `tundrasoft/deno`
- **GitHub Container Registry**: `ghcr.io/tundrasoft/deno`

```bash
# Pull from Docker Hub (recommended)
docker pull tundrasoft/deno:latest

# Pull from GitHub Container Registry
docker pull ghcr.io/tundrasoft/deno:latest

# Run a simple Deno application
docker run -d \
  -p 8080:8080 \
  -e FILE=https://deno.land/std/examples/chat/server.ts \
  --name deno-app \
  tundrasoft/deno:latest

# Run with custom timezone and permissions
docker run -d \
  -e TZ=Asia/Kolkata \
  -e ALLOW_NET=1 \
  -e ALLOW_READ=1 \
  -v $(pwd):/app \
  --name my-deno-app \
  tundrasoft/deno:latest
```

--- 
## 🏷️ Available Tags

<!-- TAGS-START -->
## Tags

| Version | Tags |
|---------|------|
| [latest](https://hub.docker.com/r/tundrasoft/deno/tags?name=latest) | Latest stable release |
| [edge](https://hub.docker.com/r/tundrasoft/deno/tags?name=edge) | Edge/development version |
| [2.4](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.4) | [2.4.4](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.4.4), [2.4.3](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.4.3), [2.4.2](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.4.2), [2.4.1](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.4.1), [2.4.0](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.4.0) |
| [2.3](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.3) | [2.3.7](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.3.7), [2.3.6](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.3.6), [2.3.5](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.3.5) |

<!-- TAGS-END -->

---

## ✨ Features

- 🦕 **Latest Deno Runtime** - Modern JavaScript/TypeScript runtime
- 🐧 **Alpine Linux Base** - Minimal, secure base OS
- 🔧 **S6 Overlay** - Advanced process supervision and service management
- 👤 **Pre-configured User** - Non-root `tundra` user (UID/GID: 1000)
- 🔒 **Granular Permissions** - Fine-grained control over Deno runtime permissions
- 🌍 **Timezone Support** - Easy timezone configuration
- ⏰ **Cron Support** - Dynamic cron job loading with environment variables
- 📊 **Health Monitoring** - Built-in health checks for application monitoring
- 🔄 **envsubst** - Environment variable substitution in config files

---

## 📖 Usage

### Basic Usage

Use as a base image in your Dockerfile:

```dockerfile
# From Docker Hub
FROM tundrasoft/deno:latest
# Your Deno application setup here
COPY . /app
```

```dockerfile
# From GitHub Container Registry
FROM ghcr.io/tundrasoft/deno:latest
# Your Deno application setup here
COPY . /app
```

For specific versions:
```dockerfile
FROM tundrasoft/deno:2.1.4
# or with specific Alpine version
FROM tundrasoft/deno:alpine-3.20-2.1.4
```

### 🎯 Running Applications

**Run a remote script:**
```bash
docker run -p 8080:8080 \
  -e FILE=https://deno.land/std/examples/chat/server.ts \
  -e ALLOW_NET=1 \
  tundrasoft/deno:latest
```

**Run with Deno tasks:**
```bash
docker run -v $(pwd):/app \
  -e TASK=start \
  -e ALLOW_ALL=1 \
  tundrasoft/deno:latest
```

**Run local application:**
```bash
docker run -v $(pwd):/app \
  -e FILE=/app/main.ts \
  -e ALLOW_NET=api.example.com \
  -e ALLOW_READ=/app \
  tundrasoft/deno:latest
```

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DENO_DIR` | Directory where cached items are stored | `/deno-dir` |
| `TASK` | Run a task from deno.json (ignores permission flags) | N/A |
| `FILE` | The file to run with permission flags | N/A |
| `PUID` | User ID for the `tundra` user | `1000` |
| `PGID` | Group ID for the `tundra` group | `1000` |
| `TZ` | Timezone (e.g., `Asia/Kolkata`, `America/New_York`) | `UTC` |

### Permission Flags

These environment variables control Deno's runtime permissions (used only with `FILE` mode):

| Variable | Description | Default |
|----------|-------------|---------|
| `ALLOW_ALL` | Enable all permissions (-A or --allow-all) | N/A |
| `ALLOW_HRTIME` | Allow high-resolution time measurement | N/A |
| `ALLOW_SYS` | Allow system information access | N/A |
| `ALLOW_ENV` | Allow environment variable access | N/A |
| `ALLOW_NET` | Network access (1 for all, or specify domains) | `1` |
| `ALLOW_READ` | File system read access (1 for all, or specify paths) | N/A |
| `ALLOW_WRITE` | File system write access (1 for all, or specify paths) | N/A |
| `ALLOW_RUN` | Command execution (1 for all, or CSV of commands) | N/A |
| `UNSTABLE` | Enable unstable APIs (specific features: ffi,cron,etc) | `0` |

> 📚 **Reference:** [Deno Permissions Documentation](https://deno.land/manual/basics/permissions)

### Volumes

| Path | Description |
|------|-------------|
| `/app` | Application root directory (recommended to mount as volume) |
| `/crons` | Directory for cron job files (automatically loaded) |
| `/deno-dir` | Deno cache directory |

---

## ⚙️ Service Management

This image uses [S6 Overlay](https://github.com/just-containers/s6-overlay) for advanced process supervision and service management.

### 🎯 Service Triggers

S6 provides dependency management through trigger points:

| Trigger | Description |
|---------|-------------|
| `os-ready` | Container booted, basic setup complete |
| `config-start` | Start configuration changes |
| `config-ready` | Configuration complete |
| `service-start` | Begin service initialization |
| `service-ready` | All services initialized |

### 📋 Built-in Services

| Service | Purpose | Dependencies |
|---------|---------|--------------|
| `config-deno` | Prepares Deno environment and directory | `config-start` |
| `deno` | Starts the Deno application | `config-deno`, `service-start` |
| `crond` | Starts cron daemon | `service-start`, `config-cron` |

### 💡 Health Monitoring

Built-in health check runs every 30 seconds:
```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s CMD /usr/bin/healthcheck.sh
```

---

## 🔧 Building

### 🏗️ Build Command

```bash
docker build \
  --build-arg ALPINE_VERSION=3.20 \
  --build-arg DENO_VERSION=2.1.4 \
  -t my-deno-image .
```

### ⚙️ Build Arguments

| Argument | Description | Example |
|----------|-------------|---------|

| `DENO_VERSION` | Deno runtime version | `2.1.4` |
| `ALPINE_VERSION` | Alpine Linux version | `3.20` |

---

## 🔒 Security

This repository implements comprehensive security scanning and best practices:

- �️ **Multi-layered scanning** with Trivy, CodeQL, Semgrep, and Grype
- � **Secret detection** with GitLeaks (runs early in build process)
- � **Automated reporting** to GitHub Security tab
- 🔄 **Daily security scans** and vulnerability monitoring
- 🔐 **Non-root execution** - Applications run as `tundra` user (UID/GID 1000)
- 🚫 **Minimal attack surface** - Only essential packages included
- 🎯 **Permission management** - Granular control over Deno runtime permissions

### 🛡️ Security Best Practices

**Container Runtime Security:**
```bash
# Run with read-only root filesystem
docker run --read-only --tmpfs /tmp --tmpfs /run tundrasoft/deno:latest

# Use specific user and drop capabilities
docker run --user 1000:1000 --cap-drop=ALL tundrasoft/deno:latest

# Limit resources
docker run --memory=512m --cpus=1 --pids-limit=100 tundrasoft/deno:latest

# Restrict network access to specific domains
docker run -e ALLOW_NET=api.example.com,cdn.jsdelivr.net tundrasoft/deno:latest
```

**File System Security:**
```bash
# Mount application files as read-only
docker run -v $(pwd):/app:ro tundrasoft/deno:latest

# Use specific read/write permissions
docker run -e ALLOW_READ=/app,/etc/ssl -e ALLOW_WRITE=/tmp tundrasoft/deno:latest

# Mount secrets securely
docker run -v /host/secrets:/secrets:ro,Z -e ALLOW_READ=/secrets tundrasoft/deno:latest
```

**Production Deployment:**
```bash
# Always use specific version tags
docker run tundrasoft/deno:2.1.4 # Not 'latest'

# Use custom networks
docker network create --driver bridge secure-app-net
docker run --network secure-app-net tundrasoft/deno:2.1.4

# Enable logging
docker run --log-driver=json-file --log-opt max-size=10m tundrasoft/deno:2.1.4
```

For security issues, please use [GitHub's private vulnerability reporting](https://github.com/TundraSoft/deno/security/advisories/new).

---

## 📚 Components

### 🦕 Deno Runtime
Modern, secure runtime for JavaScript and TypeScript built with V8 and Rust. Provides:
- Built-in TypeScript support
- Secure by default (explicit permissions)
- Standard library and tooling
- Web APIs compatibility

### 🏔️ Alpine Linux
Minimal, security-focused Linux distribution with small footprint.

### 🔧 S6 Overlay
Advanced init system and process supervisor for containers. Provides:
- Service dependency management
- Process supervision and restart
- Clean shutdown handling

### ⏰ Cron Support
Full cron daemon with dynamic job loading and environment variable substitution.

### 🔄 envsubst
GNU gettext utility for environment variable substitution in configuration files.

### 🌍 Timezone Support
Full timezone database with easy configuration via `TZ` environment variable.

### 📚 Additional Components
- **GlibC**: Required for Deno runtime compatibility
- **Health Monitoring**: Built-in health checks for application status

---

## 🤝 Contributing

1. 🍴 **Fork** the repository
2. 🌟 **Create** a feature branch: `git checkout -b feature/amazing-feature`
3. 💾 **Commit** changes: `git commit -m 'Add amazing feature'`
4. 📤 **Push** to branch: `git push origin feature/amazing-feature`
5. 🔄 **Open** a Pull Request

### 📋 Issue Templates

- 🐛 **Bug Report**: Report issues with the image
- ✨ **Feature Request**: Suggest improvements
- 🔒 **Security**: Use private vulnerability reporting

---

<div align="center">

**Built with ❤️ by [TundraSoft](https://github.com/TundraSoft)**

[View on GitHub](https://github.com/TundraSoft/deno) • [Docker Hub](https://hub.docker.com/r/tundrasoft/deno) • [Report Issue](https://github.com/TundraSoft/deno/issues)

</div>


