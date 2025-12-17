# 🦕 TundraSoft Deno Runtime Image

<!-- DESCRIPTION-START -->
A lightweight, secure Deno runtime image built on Alpine Linux with S6 overlay, comprehensive permissions management, and developer-friendly utilities.
<!-- DESCRIPTION-END -->

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
  - [Running Applications](#-running-applications)
  - [Environment Variables](#environment-variables)
  - [Permission Flags](#permission-flags)
  - [Volumes](#volumes)
- [🏗️ Build-Time Optimization](#-build-time-optimization)
- [🔧 Development Mode](#-development-mode)
- [⚙️ Service Management](#️-service-management)
- [⏰ Cron Jobs](#-cron-jobs)
- [🔧 Building](#-building)
- [🔒 Security](#-security)
- [📚 Components](#-components)
- [📖 Reference](#reference)
- [📝 Changelog](#-changelog)
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
  -e ALLOW_NET=1 \
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
| Version | Tags |
|---------|------|
| [latest](https://hub.docker.com/r/tundrasoft/deno/tags?name=latest) | Latest stable release |
| [edge](https://hub.docker.com/r/tundrasoft/deno/tags?name=edge) | Edge/development version |
| [2.5](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.5) | [2.5.6](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.5.6), [2.5.5](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.5.5), [2.5.4](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.5.4), [2.5.3](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.5.3), [2.5.2](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.5.2), [2.5.1](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.5.1), [2.5.0](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.5.0) |
| [2.4](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.4) | [2.4.5](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.4.5), [2.4.4](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.4.4), [2.4.3](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.4.3), [2.4.2](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.4.2), [2.4.1](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.4.1), [2.4.0](https://hub.docker.com/r/tundrasoft/deno/tags?name=2.4.0) |
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
FROM tundrasoft/deno:2.5.6
# or with specific Alpine version
FROM tundrasoft/deno:alpine-3.22-2.5.6
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

**Run with environment variables and permissions:**
```bash
docker run -d \
  -e FILE=/app/server.ts \
  -e ALLOW_NET=1 \
  -e ALLOW_READ=/app,/etc/config \
  -e ALLOW_WRITE=/tmp \
  -e PUID=1001 \
  -e PGID=1001 \
  -e TZ=America/New_York \
  -v $(pwd):/app \
  tundrasoft/deno:latest
```

### Environment Variables

<!-- ENV-VARS-START -->
| Variable | Description | Default |
|----------|-------------|---------|
| `DENO_DIR` | Directory where cached items are stored | `/deno-dir` |
| `TASK` | Run a task from deno.json (ignores permission flags) | N/A |
| `FILE` | The file to run with permission flags | N/A |
| `PUID` | User ID for the `tundra` user | `1000` |
| `PGID` | Group ID for the `tundra` group | `1000` |
| `TZ` | Timezone (e.g., `Asia/Kolkata`, `America/New_York`) | `UTC` |
| `DENO_LOG` | Deno logging level (e.g., `debug`, `info`) | N/A |
| `DENO_NO_LOCK` | Disable lock file generation (1 to disable) | N/A |
| `DEBUG` | Enable debug mode with verbose output (1 to enable) | N/A |
| `WATCH` | Enable watch mode for file changes (1 to enable) | N/A |
| `S6_CMD_WAIT_FOR_SERVICES_MAXTIME` | Max time (ms) to wait for services to start (0 = infinite) | `0` |
| `S6_KILL_FINISH_MAXTIME` | Grace period (ms) for graceful shutdown | `5000` |
<!-- ENV-VARS-END -->

### Permission Flags

These environment variables control Deno's runtime permissions (used only with `FILE` mode):

<!-- PERMISSIONS-START -->
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
<!-- PERMISSIONS-END -->

> 📚 **Reference:** [Deno Permissions Documentation](https://deno.land/manual/basics/permissions)

### Volumes

| Path | Description |
|------|-------------|
| `/app` | Application root directory (recommended to mount as volume) |
| `/crons` | Directory for cron job files (automatically loaded) |
| `/deno-dir` | Deno cache directory (for persisting dependencies) |

---

## 🏗️ Build-Time Optimization

### Cache Warming for Faster Deployments

Pre-warm the Deno cache during image build to eliminate cold-start dependency downloads:

**Simple file caching:**
```dockerfile
FROM tundrasoft/deno:latest

COPY . /app

# Pre-warm cache during build
RUN deno cache /app/main.ts

ENV FILE=/app/main.ts
ENV ALLOW_NET=1
```

**With dependencies file:**
```dockerfile
FROM tundrasoft/deno:latest

COPY deps.ts /app/
COPY main.ts /app/

# Cache all dependencies first (better layer caching)
RUN deno cache /app/deps.ts
# Then cache the main app
RUN deno cache /app/main.ts

ENV FILE=/app/main.ts
ENV ALLOW_NET=1
```

**With deno.json tasks:**
```dockerfile
FROM tundrasoft/deno:latest

COPY . /app

# Cache dependencies defined in deno.json
RUN deno cache --reload /app/deno.json

ENV TASK=start
ENV ALLOW_ALL=1
```

**Multi-stage optimized build:**
```dockerfile
FROM tundrasoft/deno:latest AS cache

COPY deno.lock deps.ts /app/
RUN deno cache --reload /app/deps.ts

FROM tundrasoft/deno:latest

# Copy pre-cached dependencies
COPY --from=cache /deno-dir /deno-dir
COPY . /app

RUN deno cache /app/main.ts

ENV FILE=/app/main.ts
ENV ALLOW_NET=1
```

### Benefits

- ⚡ **Faster cold starts** - No dependency downloads at runtime
- 📦 **Reproducible builds** - Same dependencies every build
- 🔒 **Offline compatible** - Works in isolated environments
- 🎯 **Layer caching** - Separate cache layer for better Docker caching
- 🚀 **Production ready** - No surprise downloads in production

---

## 🔧 Development Mode

### Development setup

Development mode combines `DEBUG`, `WATCH`, and `DENO_LOG` for optimal developer experience:

**Development setup:**
```bash
docker run -it \
  -e DEBUG=1 \
  -e WATCH=1 \
  -e DENO_LOG=debug \
  -e FILE=/app/main.ts \
  -e ALLOW_ALL=1 \
  -v $(pwd):/app \
  -p 8080:8080 \
  tundrasoft/deno:latest
```

**What this enables:**
- 🐛 `DEBUG=1`: Verbose startup output with argument inspection
- 👁️ `WATCH=1`: File watching with auto-restart on changes
- 📋 `DENO_LOG=debug`: Detailed Deno runtime logging

**With Deno tasks:**
```bash
docker run -it \
  -e DEBUG=1 \
  -e WATCH=1 \
  -e TASK=dev \
  -v $(pwd):/app \
  -p 8080:8080 \
  tundrasoft/deno:latest
```

**Lock file disabled (useful for read-only containers):**
```bash
docker run -d \
  -e DENO_NO_LOCK=1 \
  -e FILE=/app/server.ts \
  -e ALLOW_NET=1 \
  -v /app:ro \
  tundrasoft/deno:latest
```

---

## ⚙️ Service Management

This image uses [S6 Overlay](https://github.com/just-containers/s6-overlay) for advanced process supervision and service management. S6 is a lightweight init system that provides reliable service supervision, dependency management, and graceful shutdown handling.

The Deno service runs your application via the S6 system, ensuring:
- Automatic restart on failure
- Graceful shutdown handling
- Proper signal handling
- Logging integration
- Health monitoring

### Service Startup & Shutdown Configuration

Control S6 service supervision timeouts:

```bash
# Custom startup timeout (30 seconds max wait)
docker run -d \
  -e S6_CMD_WAIT_FOR_SERVICES_MAXTIME=30000 \
  -e FILE=/app/server.ts \
  tundrasoft/deno:latest

# Extended graceful shutdown (10 seconds)
docker run -d \
  -e S6_KILL_FINISH_MAXTIME=10000 \
  -e FILE=/app/server.ts \
  tundrasoft/deno:latest

# Infinite startup wait (for slow-starting apps)
docker run -d \
  -e S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
  -e FILE=/app/server.ts \
  tundrasoft/deno:latest
```

### 🎯 Service Triggers

S6 provides dependency management through trigger points:

| Trigger | Description |
|---------|-------------|
| `os-ready` | Container booted, basic setup complete |
| `config-start` | Start configuration changes |
| `config-ready` | Configuration complete |
| `service-start` | Application services begin |
| `service-ready` | All services initialized |

### Adding Custom Services

You can extend the Deno image with additional services:

```dockerfile
FROM tundrasoft/deno:latest

# Install additional tools
RUN apk add --no-cache redis

# Create Redis service
RUN mkdir -p /etc/s6-overlay/s6-rc.d/redis/dependencies.d
RUN echo "longrun" > /etc/s6-overlay/s6-rc.d/redis/type

RUN cat > /etc/s6-overlay/s6-rc.d/redis/run << 'EOF'
#!/command/with-contenv sh
exec 2>&1
exec redis-server --bind 127.0.0.1
EOF

RUN chmod +x /etc/s6-overlay/s6-rc.d/redis/run
RUN touch /etc/s6-overlay/s6-rc.d/redis/dependencies.d/service-start
RUN touch /etc/s6-overlay/s6-rc.d/user/contents.d/redis
```

---

## ⏰ Cron Jobs

### Dynamic Cron Setup

This image provides dynamic cron job loading with environment variable substitution support:

1. **Create cron files** in the `/crons` directory
2. **Use environment variables** with `$VARIABLE_NAME` syntax
3. **Pass environment variables** when running the container
4. **S6 automatically** loads and installs jobs at startup

### Cron Examples

#### Example 1: Basic Scheduled Task

**File:** `/crons/daily-cleanup`
```bash
# Run cleanup at 3 AM daily
0 3 * * * find /tmp -type f -mtime +7 -delete
```

**Run container:**
```bash
docker run -d \
  -v /host/crons:/crons:ro \
  tundrasoft/deno:latest
```

#### Example 2: Application Health Check

**File:** `/crons/health-check`
```bash
# Check application health every 5 minutes
*/5 * * * * curl -f http://localhost:8080/health || exit 1
```

**Run container:**
```bash
docker run -d \
  -p 8080:8080 \
  -e FILE=/app/server.ts \
  -e ALLOW_NET=1 \
  -v /host/crons:/crons:ro \
  -v $(pwd):/app \
  tundrasoft/deno:latest
```

#### Example 3: Complex Configuration

**File:** `/crons/maintenance-jobs`
```bash
# Database backup
$BACKUP_TIME /usr/local/bin/backup.sh >> /var/log/cron-backup.log 2>&1

# Log rotation
$LOG_ROTATE_TIME logrotate /etc/logrotate.conf

# Cleanup caches
$CLEANUP_TIME rm -rf /tmp/deno-cache-*
```

**Run container with environment substitution:**
```bash
docker run -d \
  -e BACKUP_TIME='0 2 * * *' \
  -e LOG_ROTATE_TIME='0 0 * * *' \
  -e CLEANUP_TIME='0 4 * * 0' \
  -v /host/crons:/crons:ro \
  tundrasoft/deno:latest
```

---

## 🔧 Building

### 🏗️ Build Command

```bash
docker build \
  --build-arg ALPINE_VERSION=latest \
  --build-arg DENO_VERSION=2.5.6 \
  -t my-deno-image .
```

### ⚙️ Build Arguments

<!-- BUILD-ARGS-START -->
| Argument | Description | Example |
|----------|-------------|---------|
| `ALPINE_VERSION` | Alpine Linux version (base image) | `latest`, `3.22`, `3.21` |
| `DENO_VERSION` | Deno runtime version | `2.5.6`, `2.4.5`, `2.3.7` |
<!-- BUILD-ARGS-END -->

---

## 🔒 Security

This repository implements comprehensive security scanning:

- 🛡️ **Multi-layered scanning** with Trivy, CodeQL, Semgrep, and Grype
- 🔍 **Secret detection** with GitLeaks (runs early in build process)
- 📊 **Automated reporting** to GitHub Security tab
- 🔄 **Daily security scans** and vulnerability monitoring

### Permission Model

Deno provides fine-grained permissions for runtime security:

```bash
# Minimal permissions (read-only access)
docker run -e FILE=/app/script.ts \
  -e ALLOW_READ=/app \
  tundrasoft/deno:latest

# Network with specific domain whitelist
docker run -e FILE=/app/fetch.ts \
  -e ALLOW_NET=api.example.com,cdn.jsdelivr.net \
  tundrasoft/deno:latest

# Restricted execution (no command execution)
docker run -e FILE=/app/processor.ts \
  -e ALLOW_READ=/app \
  -e ALLOW_WRITE=/tmp \
  tundrasoft/deno:latest
```

For security issues, please use [GitHub's private vulnerability reporting](https://github.com/TundraSoft/deno/security/advisories/new).

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

### Base System
- **Alpine Linux 3.22** - Minimal, secure, and reliable
- **S6 Overlay v3** - Process supervision with lifecycle management
- **OpenSSL 3.x** - Cryptographic and TLS support

### Runtime
- **Deno 2.5.6** - Modern JavaScript/TypeScript runtime
- **Node.js runtime support** - Via Deno's Node compatibility
- **TypeScript 5.x** - Built-in TypeScript support

### Utilities
- **cURL** - HTTP client for network operations
- **Git** - Version control (for development)
- **Bash/sh** - Shell scripting
- **Healthcheck script** - S6-integrated service monitoring

---

## 📖 Reference

### Container Lifecycle

| Stage | Description | Services |
|-------|-------------|----------|
| Boot | Initialize system and user | `os-ready` → `service-ready` |
| Config | Load configuration | `config-start` → `config-ready` |
| Main | Run application/cron | `deno` or `crond` |
| Shutdown | Clean termination | S6 async handlers |

### Directory Structure

```
/deno-dir/        - Deno cache directory (mounted volume)
/app/             - Application code
/etc/s6-overlay/  - S6 service definitions
/etc/crontabs/    - Cron jobs (if using cron)
/etc/timezone     - TZ configuration
/run/s6/          - S6 runtime (temporary)
```

### Docker Compose Example

```yaml
version: '3.8'

services:
  app:
    image: tundrasoft/deno:latest
    environment:
      - FILE=/app/src/main.ts
      - ALLOW_NET=api.example.com
      - ALLOW_READ=/app
      - ALLOW_WRITE=/tmp
    volumes:
      - ./src:/app
      - deno-cache:/deno-dir
    ports:
      - "8000:8000"
    healthcheck:
      test: ["CMD", "/usr/bin/healthcheck.sh"]
      interval: 30s
      timeout: 10s
      retries: 3

volumes:
  deno-cache:
```

### Troubleshooting

**Issue: "Permission denied" errors**
```bash
# Verify permissions with ALLOW_READ, ALLOW_WRITE, ALLOW_NET
docker run -e ALLOW_READ=/app -e ALLOW_WRITE=/tmp \
  -e ALLOW_NET=api.example.com tundrasoft/deno:latest
```

**Issue: Application not starting**
```bash
# Check logs and healthcheck
docker logs <container-id>
docker exec <container-id> /usr/bin/healthcheck.sh
```

**Issue: Slow startup**
- First run downloads Deno modules (see ALLOW_NET for network)
- Use volume mount for `/deno-dir` to preserve cache
- Consider prewarming with multi-stage builds

---

## 🤝 Contributing

1. 🍴 **Fork** the repository
2. 🌟 **Create** a feature branch: `git checkout -b feature/amazing-feature`
3. 💾 **Commit** changes: `git commit -m 'Add amazing feature'`
4. 📤 **Push** to branch: `git push origin feature/amazing-feature`
5. 🔄 **Open** a Pull Request

### 📋 Changelog

See [CHANGELOG.md](CHANGELOG.md) for release notes and [CHANGELOG-GUIDE.md](CHANGELOG-GUIDE.md) for contribution guidelines.

---

**Built with ❤️ by [TundraSoft](https://github.com/TundraSoft)**

[View on GitHub](https://github.com/TundraSoft/deno) • [Docker Hub](https://hub.docker.com/r/tundrasoft/deno) • [Report Issue](https://github.com/TundraSoft/deno/issues)
