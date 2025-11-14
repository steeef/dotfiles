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
      model = "gpt-5-codex";
      approval_policy = "on-request";
      sandbox_mode = "workspace-write";
      sandbox_workspace_write = {
        network_access = true;
        writable_roots = [
          "/Users/sprice/.cache/uv"
          "/Users/sprice/.local/share/uv/tools"
          "/Users/sprice/.cache/pre-commit"
        ];
      };
    };
  };
}
