# Claude Code configuration
#
# Hooks are provided by claude-hooks plugins installed via:
#   /plugin marketplace add steeef/claude-hooks
#   /plugin install <plugin>@claude-hooks
{
  inputs,
  pkgs,
  lib,
  ...
}: {
  # Install claude-powerline globally
  home.packages = with pkgs; [
    claude-powerline
  ];

  # Claude powerline configuration
  home.file.".claude/claude-powerline.json".source = ./claude-powerline.json;

  # Custom commands
  home.file.".claude/commands/create_handoff.md".source = ./commands/create_handoff.md;
  home.file.".claude/commands/resume_handoff.md".source = ./commands/resume_handoff.md;
  home.file.".claude/commands/research_codebase.md".source = ./commands/research_codebase.md;
  home.file.".claude/commands/convergent_review.md".source = ./commands/convergent_review.md;
  home.file.".claude/commands/iterate_plan.md".source = ./commands/iterate_plan.md;
  home.file.".claude/commands/validate_plan.md".source = ./commands/validate_plan.md;

  # Use official home-manager claude-code module
  programs.claude-code = {
    enable = true;
    # Use updated package from sadjow flake
    package = inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default;
    # Import settings from existing JSON file
    settings = lib.importJSON ./settings.json;
  };

  # Still need activation script for memory.md since official module doesn't handle it
  home.activation.claude-memory = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Copy memory file to CLAUDE.md
    install -m 644 ${./memory.md} $HOME/.claude/CLAUDE.md
  '';
}
