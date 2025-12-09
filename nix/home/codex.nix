{
  inputs,
  pkgs,
  ...
}: {
  programs.codex = {
    enable = true;
    package = inputs.codex-cli.packages.${pkgs.stdenv.hostPlatform.system}.default;
    custom-instructions = builtins.readFile ./claude/memory.md;
    settings = {
      model = "gpt-5.1-codex-max";
      approval_policy = "on-request";
      sandbox_mode = "workspace-write";
      notice = {
        hide_gpt5_1_migration_prompt = true;
        "hide_gpt-5.1-codex-max_migration_prompt" = true;
      };
      sandbox_workspace_write = {
        network_access = true;
        writable_roots = [
          "/Users/sprice/Library/Caches/uv"
          "/Users/sprice/.cache/uv"
          "/Users/sprice/.local/share/uv/tools"
          "/Users/sprice/.cache/pre-commit"
        ];
      };
    };
  };
}
