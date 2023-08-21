#!/bin/sh

# /package/admin/s6/command/s6-svstat /run/s6-rc/servicedirs/deno || exit 1

SERVICE=$(/package/admin/s6/command/s6-svstat /run/s6-rc/servicedirs/deno)
if echo "$SERVICE" | grep -q "down"; then
  echo "$SERVICE"
  exit 1
else
  echo "$SERVICE"
fi