# Claude Code configuration
#
# Requires: Clone https://github.com/steeef/claude-code-tools to ~/code/claude-code-tools
# and set CLAUDE_CODE_TOOLS_PATH environment variable
{
  inputs,
  pkgs,
  lib,
  ...
}: {
  # Install claude-code package from sadjow flake
  home.packages = [ inputs.claude-code.packages.${pkgs.system}.default ];

  # Custom activation script to manage Claude configuration files
  home.activation.claude-config = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Create ~/.claude directory structure
    mkdir -p $HOME/.claude/hooks

    # Copy memory file
    install -m 644 ${./memory.md} $HOME/.claude/CLAUDE.md

    # Copy settings.json file
    install -m 644 ${./settings.json} $HOME/.claude/settings.json
  '';
}
