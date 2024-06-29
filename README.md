# TundraSoft - Deno

[![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/TundraSoft/deno/build-docker.yml?event=push&logo=github)](https://github.com/TundraSoft/deno/actions/workflows/build-docker.yml?logo=github)
[![GitHub issues](https://img.shields.io/github/issues-raw/tundrasoft/deno.svg?logo=github)](https://github.com/tundrasoft/deno/issues)
[![GitHub PRs](https://img.shields.io/github/issues-pr-raw/tundrasoft/deno.svg?logo=github)](https://github.com/tundrasoft/deno/pulls) 
[![License](https://img.shields.io/github/license/tundrasoft/deno.svg)](https://github.com/tundrasoft/deno/blob/master/LICENSE)

[![Repo size](https://img.shields.io/github/repo-size/tundrasoft/deno?logo=github)](#)
[![Docker image size](https://img.shields.io/docker/image-size/tundrasoft/deno?logo=docker)](https://hub.docker.com/r/tundrasoft/deno)

[![Docker Pulls](https://img.shields.io/docker/pulls/tundrasoft/deno.svg?logo=docker)](https://hub.docker.com/r/tundrasoft/deno)

![Deno Mascot](https://deno.land/logo.svg)

Docker container for Deno. This is meant to be a lightweight docker image built on alpine. The run commands are present as 
env variables to keep things simple.

## Usage

This can either be used as the base containe from which you build your deno 
application or use the image as is, move your files.

You can run the container by:
```docker
docker run --name deno -p 8080:8080 -e FILE=https://deno.land/std/examples/chat/server.ts tundrasoft/deno:latest
```

Once it has booted, you can go check http://localhost:8080/ and the chat window must appear.

**NOTE** Port 8080 is used here s that is the port configured in the example.
 Change this to suite your application.

If you would like to build basis this image then simply use this in the FROM 
statement in docker file:

```docker
FROM tundrasoft/deno:latest
```

or tag to a specific version
```docker
FROM tundrasoft/deno:1.34.0
```

### Environment variables

Below are the environment variables available

| Name | Description | Default Value |
|---|---|---|
| DENO_DIR | The directory where cached items are stored | /deno-dir |
| TASK | If there is a deno.json file and contains "tasks" section, then run the task. All permission flags are ignored | N/A |
| FILE | The file to run. The permission flags are added when running | N/A |
| PUID | The User ID (created) | 1000 |
| PGID | The Group ID (created) | 1000 |
| TZ | The timezone to set | UTC |

Below are the permission flags (env args). These args will only be used if FILE mode is used
| Name | Description | Default Value |
|---|---|---|
| ALLOW_ALL | This is the deno run argument. Will set -A or --allow-all | |
| ALLOW_HRTIME | This will allow --allow-hrtime flag to be set for deno | |
| ALLOW_SYS | This will set the --allow-sys flag. | |
| ALLOW_ENV | This will set the --allow-env flag | | 
| ALLOW_NET | This will set the --allow-net flag. Set to 1 to enable network access to anywhere | 1 |
| READ_PATHS | This will set the --allow-read flag. Set to 1 to enable read any path | /app |
| WRITE_PATHS | This will set the --allow-write flag. Set to 1 to enable write in any path | /app |
| ALLOW_RUN | This will set the --allow-run flag. Set to 1 to allow execution of any command | |
| UNSTABLE | Enable unstable API. Set to 1 to allow. Use this with caution | 0 |

Refer documentation of deno at [Deno Permissions](https://deno.land/manual/basics/permissions)

### S6 Events

Below are the "events" which are provided by this container during startup:
| Name | Depends On | Action |
|--- | --- | --- |
| config-deno | config-start | Prepares the environment (Deno directory etc) |
| deno | config-deno & service-start | Starts the deno app |

### Volumes

`/app` - This is the application root folder were the applicatiom files will 
reside. This can and ideally should be exposed as a volume

`/crons` - This is a helper path to set cron jobs.

### Ports

No ports are exposed by default. Simply expose the ports basis your application configuration.

### Monitoring

There is a healthcheck present which checks the status of deno service. It 
runs every 30 seconds. 

```docker
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s CMD /usr/bin/healthcheck.sh
```

## Building the image

The image can be built using the below command

```sh
docker build --no-cache --build-arg ALPINE_VERSION=3.18 --build-arg DENO_VERSION=1.32.3 -t tundrasoft/deno .
```

### Build Arguments

Below are the arguments available:


| Name | Description |
|---|---|
| DENO_VERSION | The version of deno to use. |
| ALPINE_VERSION | The version of alpine to build on, defaults to latest |

## Installed Components

### [`Deno`](https://deno.land/ "Deno")

Deno is a _simple_, _modern_ and _secure_ runtime for **JavaScript** and
**TypeScript** that uses V8 and is built in Rust.

### [`S6`]([!https://github.com/just-containers/s6-overlay#the-docker-way "S6 Github link")

The s6-overlay-builder project is a series of init scripts and utilities to ease creating Docker images using s6 as a process supervisor.

### Time Zone

Timezone is available pre-packaged. To set timezone, pass environment variable TZ, example TZ=Asia/Kolkata
**NOTE** This does not setup NTP or other service. The time is still fetched from the underlying host. The timezone is applied thereby
displaying the correct time.

### envsubst

Added envsubst to help in applying environment variables in config files. 

### GlibC

GLIBC package is installed as deno requires this
