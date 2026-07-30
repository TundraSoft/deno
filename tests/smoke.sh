#!/usr/bin/env bash
# Smoke test for the tundrasoft/deno image. Boots via the s6 entrypoint, so each
# check also proves s6 came up. Usage: tests/smoke.sh <image> [expected-deno-version]
set -euo pipefail

IMG="${1:?usage: smoke.sh <image> [expected-deno-version]}"
EXPECTED_DENO="${2:-}"
FIX="$(cd "$(dirname "$0")/fixtures" && pwd)"

fail() { printf '\033[31mFAIL\033[0m %s\n' "$*" >&2; exit 1; }
pass() { printf '\033[32mPASS\033[0m %s\n' "$*"; }

# Poll a container's logs for a pattern, up to <timeout> seconds.
wait_log() {
  cid="$1"; pat="$2"; t="${3:-20}"; i=0
  while [ "$i" -lt "$t" ]; do
    if docker logs "$cid" 2>&1 | grep -qF "$pat"; then return 0; fi
    i=$((i + 1)); sleep 1
  done
  return 1
}

# Boot detached, wait for <marker>, echo the logs, always clean up. Args after
# marker/timeout go to `docker run`.
boot_expect() {
  marker="$1"; timeout="$2"; shift 2
  cid="$(docker run -d -e S6_VERBOSITY=1 "$@" "$IMG")"
  if wait_log "$cid" "$marker" "$timeout"; then
    docker logs "$cid" 2>&1
    docker rm -f "$cid" >/dev/null
    return 0
  fi
  docker logs "$cid" >&2 2>&1 || true
  docker rm -f "$cid" >/dev/null
  return 1
}

# 1. Deno version
if [ -n "$EXPECTED_DENO" ]; then
  docker run --rm -e S6_VERBOSITY=1 "$IMG" deno --version | grep -qF "$EXPECTED_DENO" \
    || fail "deno --version does not report '$EXPECTED_DENO'"
  pass "deno reports version $EXPECTED_DENO"
else
  docker run --rm -e S6_VERBOSITY=1 "$IMG" deno --version | grep -q '^deno ' \
    || fail "deno --version produced no output"
  pass "deno binary runs"
fi

# 2. Default service boots the welcome app and stays up
boot_expect 'Welcome to Deno' 20 >/dev/null \
  || fail "default container did not print the welcome banner"
pass "default service boots"

# 3. FILE mode permission wiring: env denied by default, granted via ALLOW_ENV
logs="$(boot_expect 'SMOKE_ENV=' 20 -v "$FIX/app:/smoke:ro" -e FILE=/smoke/env.ts -e SMOKE_VAR=hello)" \
  || fail "FILE mode (deny case) produced no marker"
printf '%s\n' "$logs" | grep -qF 'SMOKE_ENV=DENIED' \
  || fail "env access should be DENIED without ALLOW_ENV"
pass "FILE mode denies env by default"

logs="$(boot_expect 'SMOKE_ENV=' 20 -v "$FIX/app:/smoke:ro" -e FILE=/smoke/env.ts -e SMOKE_VAR=hello -e ALLOW_ENV=1)" \
  || fail "FILE mode (allow-all case) produced no marker"
printf '%s\n' "$logs" | grep -qF 'SMOKE_ENV=hello' \
  || fail "ALLOW_ENV=1 should grant env access"
pass "ALLOW_ENV=1 grants env access"

# scoped value -> --allow-env=SMOKE_VAR
logs="$(boot_expect 'SMOKE_ENV=' 20 -v "$FIX/app:/smoke:ro" -e FILE=/smoke/env.ts -e SMOKE_VAR=hello -e ALLOW_ENV=SMOKE_VAR)" \
  || fail "FILE mode (scoped case) produced no marker"
printf '%s\n' "$logs" | grep -qF 'SMOKE_ENV=hello' \
  || fail "scoped ALLOW_ENV=SMOKE_VAR should grant env access"
pass "scoped ALLOW_ENV=SMOKE_VAR grants env access"

# 4. TASK mode (writable /app for the lockfile)
workdir="$(mktemp -d)"
cp "$FIX/task/deno.json" "$workdir/deno.json"
if logs="$(boot_expect 'SMOKE_TASK_OK' 25 -v "$workdir:/app" -e TASK=smoke)"; then
  rm -rf "$workdir"
else
  rm -rf "$workdir"; fail "TASK mode did not run the task"
fi
printf '%s\n' "$logs" | grep -qF 'SMOKE_TASK_OK' || fail "TASK mode marker missing"
pass "TASK mode runs deno task"

echo
pass "all smoke tests passed for $IMG"
