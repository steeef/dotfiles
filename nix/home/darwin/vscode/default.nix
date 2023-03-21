{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      dracula-theme.theme-dracula
      hashicorp.terraform
      ms-python.python
      timonwong.shellcheck
      vscodevim.vim
    ];
  };
}
