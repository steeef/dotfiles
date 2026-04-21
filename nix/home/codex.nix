{
  inputs,
  pkgs,
  ...
}: {
  programs.codex = {
    enable = true;
    package = inputs.codex-cli.packages.${pkgs.stdenv.hostPlatform.system}.default;
    context = ./claude/memory.md;
  };
}
