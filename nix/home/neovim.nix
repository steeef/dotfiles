{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    withNodeJs = true;

    extraPackages = with pkgs; [
      actionlint
      black
      helm-ls
      markdown-oxide
      nil
      ripgrep
      shellcheck
      shfmt
      statix
      lua-language-server
      terraform-ls
      tflint
      nodePackages.bash-language-server
      nodePackages.yaml-language-server
      vscode-langservers-extracted
    ];
  };
}
