// smoke.sh fixture: prints whether --allow-env was granted, then stays alive.
let value: string;
try {
  value = Deno.env.get("SMOKE_VAR") ?? "unset";
} catch (_err) {
  value = "DENIED";
}
console.log("SMOKE_ENV=" + value);
setInterval(() => {}, 60_000);
