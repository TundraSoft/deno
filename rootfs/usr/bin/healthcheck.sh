#!/bin/sh

/package/admin/s6/command/s6-svstat /run/s6-rc/servicedirs/deno || exit 1