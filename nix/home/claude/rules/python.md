---
paths:
  - "**/*.py"
  - "**/pyproject.toml"
  - "**/poetry.lock"
---

# Python tooling

- Use global `poetry` command. Different Python: `uvx --python <ver> --with poetry==<ver> poetry ...` (e.g. `uvx --python 3.12 --with poetry==2.1.3 poetry install`).
- `poetry lock` (no flags) regenerates lock file. `--no-update` flag does not exist.
- When invoking `uv` or `uvx`, request escalated permissions so sandboxed `os.sysconf` calls don't fail with `PermissionError`.
- Single-file Python: use `uv` with PEP 723 inline script metadata (`#!/usr/bin/env -S uv run --script` + `# /// script ... # ///` block). See <https://docs.astral.sh/uv/guides/scripts/>.
