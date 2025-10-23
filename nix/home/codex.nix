{ inputs, pkgs, ... }: {
  programs.codex = {
    enable = true;
    package = inputs.codex-cli.packages.${pkgs.system}.default;
    custom-instructions = builtins.readFile ./claude/memory.md;
  };
}
