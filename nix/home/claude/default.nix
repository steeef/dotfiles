# Claude Code configuration
#
# Hooks are provided by claude-hooks plugins installed via:
#   /plugin marketplace add steeef/claude-hooks
#   /plugin install <plugin>@claude-hooks
{
  pkgs,
  lib,
  inputs,
  ...
}: let
  jsonFormat = pkgs.formats.json {};
  baseSettings = lib.importJSON ./settings.json;
  baseSettingsFile = jsonFormat.generate "claude-code-base-settings.json" (
    baseSettings // {"$schema" = "https://json.schemastore.org/claude-code-settings.json";}
  );
in {
  # Install claude-powerline globally
  home.packages = with pkgs; [
    claude-powerline
  ];

  # Claude powerline configuration
  home.file.".claude/claude-powerline.json".source = ./claude-powerline.json;

  # Agent definitions (Nix-managed)
  home.file.".claude/agents/batch-reader.md" = {
    source = ./agents/batch-reader.md;
    force = true;
  };
  home.file.".claude/agents/budgeted-explore.md" = {
    source = ./agents/budgeted-explore.md;
    force = true;
  };

  # Nix base settings (read-only reference for merge)
  home.file.".claude/settings.nix.json".source = baseSettingsFile;

  # Merge Nix base into mutable settings.json on every hms
  home.activation.mergeClaudeSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    base="$HOME/.claude/settings.nix.json"
    target="$HOME/.claude/settings.json"

    # Transition: remove symlink from previous Nix management
    if [ -L "$target" ]; then
      run rm "$target"
    fi

    if [ -f "$target" ]; then
      # Deep merge: existing + Nix base (Nix wins for scalar conflicts)
      run ${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$target" "$base" > "$target.tmp"
      run mv "$target.tmp" "$target"
    else
      # No existing settings — copy base as mutable file
      run cp "$base" "$target"
      run chmod 644 "$target"
    fi
  '';

  # Use official home-manager claude-code module
  programs.claude-code = {
    enable = true;
    package = inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default;
    # Settings managed via activation script merge (see below)
    # Custom skills directory
    skillsDir = ./skills;
    # Memory file for CLAUDE.md
    memory.source = ./memory.md;
  };
}
