{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    withNodeJs = true;

    extraPackages = with pkgs; [
      actionlint
      black
      helm-ls
      marksman
      nil
      ripgrep
      ruff-lsp
      shellcheck
      shfmt
      statix
      sumneko-lua-language-server
      terraform-ls
      tflint
      nodePackages.bash-language-server
      nodePackages.vscode-json-languageserver
      nodePackages.yaml-language-server
    ];
  };
}
