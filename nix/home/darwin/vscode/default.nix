{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      dracula-theme.theme-dracula
      hashicorp.terraform
      timonwong.shellcheck
      vscodevim.vim
    ];
  };
}
