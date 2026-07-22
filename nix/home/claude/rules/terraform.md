---
paths:
  - "**/*.tf"
  - "**/*.tofu"
  - "**/.terraform-version"
  - "**/.tool-versions"
---

# Terraform tooling

- IMPORTANT: Use `tenv` for Terraform version management (NOT `tfenv` — not installed). `tenv tf install <ver>` / `tenv tf use <ver>`; respects `.terraform-version` / `.tool-versions`. `tenv` also manages tofu/terragrunt/atmos via `tenv tofu|tg|atmos`.
