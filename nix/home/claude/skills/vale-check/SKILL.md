---
name: vale-check
description: >
  Runs the Vale prose linter (vale.sh) against a markdown document or an
  in-progress draft, using a config tuned to cut noise from Google-style
  acronym/punctuation nitpicks while keeping real signal: passive voice,
  wordiness, weasel words, unverifiable claims, and other common LLM/AI
  writing tells. Advisory only, never a gate. Use whenever the user says
  "run vale against this", "vale check this", "lint this with vale", asks
  to check a draft for AI-writing tells or whether it reads like it was
  written by AI, or asks for a prose/style check before publishing a draft
  to Confluence, Slack, or Marquee, or before finishing a PRD, plan, or
  research doc. Also use proactively right before any of those publish
  steps, unless the user has said not to. Do NOT use for code review,
  grammar-only requests better served by a spell checker, or non-prose
  files.
---

# Vale check

Local-only prose lint. No CI, no pre-commit hook — this runs in-session,
on demand, and never blocks a publish.

## Steps

1. **Get the content into a `.md` file.** Vale needs a real file with a
   markdown extension to pick the right parser.
   - Already a file on disk (thoughts doc, PRD, plan)? Use that path
     directly.
   - Still just a draft in the conversation (a Slack announcement, a
     Confluence page body, a Marquee post) and not yet saved anywhere?
     Write it to a scratch file via Bash, not the Write tool, e.g.
     `cat > /tmp/vale-check-$$.md <<'EOF' ... EOF`.
2. Run the bundled script against that path:

   ```bash
   ~/.claude/skills/vale-check/run.sh /path/to/file.md
   ```

   First run syncs the `write-good` and `Google` style packages
   (network call, one-time); later runs are instant.
3. Report findings back to the user in plain language, grouped by rule,
   not as a raw dump of the tool output. Offer to fix them; don't fix
   silently.
4. Delete any scratch file you created in step 1.
5. Never treat a nonzero step-2 exit or nonempty output as a blocker —
   surface it and let the user decide whether to publish anyway.

## Why this config, not vanilla Vale

Full `write-good` and `Google` packages flood technical/internal docs
with false positives — E-Prime bans every "is/was", Google's Acronyms
rule fires on every `SRE`/`EKS`/`JWT`, Colons/Headings/EmDash fight
normal punctuation and Title Case. The bundled `vale.ini` disables those
and keeps only the rules that held up against a real 431-doc corpus:
`write-good` (minus E-Prime) plus `Google.ExcessiveClaims` and
`Google.Anthropomorphism`.

Edit `~/.config/vale-check/.vale.ini` directly to retune — it's a
bootstrapped copy of this skill's `vale.ini`, safe to edit without
touching the dotfiles-managed original.
