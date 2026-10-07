# Claude Code telemetry (ltm-3914 only)

Local OTLP stack: Claude Code → Prometheus (metrics) + Loki (events) → Grafana.
Defined in `nix/home/darwin/telemetry.nix`; attached only to
`homeConfigurations."sprice@ltm-3914"` via `extraModules` in `flake.nix`.

## Endpoints

- Grafana `http://127.0.0.1:3000/d/claude-code/claude-code` (anonymous admin, loopback only)
- Prometheus `:9090` (OTLP at `/api/v1/otlp/v1/metrics`), Loki `:3100` (OTLP at `/otlp/v1/logs`)
- Data: `~/.local/share/claude-telemetry/`; logs: `~/Library/Logs/claude-telemetry/`
- Retention: 2 years for both. Agents: `launchctl list | grep claude-`

## Gotchas

- Claude Code gets its `OTEL_*` vars from `home.sessionVariables`. A shell started
  before `hms` carries `__HM_SESS_VARS_SOURCED=1` and never loads them; restart
  the terminal multiplexer. The Bash tool's `env` doesn't show `OTEL_*` even when
  the process has them; check Prometheus instead.
- `claude -p` children (conductor `session-end.sh` summarizer) don't inherit
  `OTEL_*`. The same vars are also merged into `~/.claude/settings.json` `env`
  by `claudeTelemetrySettingsEnv` (`telemetry.nix`), so every Claude process
  exports regardless of shell env.
- Counters are cumulative (Prometheus rejects delta), one series per session.
  Dashboard queries use `max_over_time`, not `increase()`, which drops each
  series' first sample. A session spanning midnight counts fully on each day.
- Day buckets align to UTC midnight (5pm Pacific).
- `OTEL_LOG_TOOL_DETAILS=1` stores tool arguments (commands, paths) in Loki;
  needed for skill names. Drop it to stop storing them.
- Metrics and events only exist from first setup; there is no backfill.

## Verify

`curl -s 'http://127.0.0.1:9090/api/v1/query?query=count(count%20by%20(session_id)(claude_code_session_count_total))'`
