{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    withNodeJs = true;

    extraPackages = with pkgs; [
      actionlint
      black
      marksman
      nil
      ripgrep
      shellcheck
      shfmt
      statix
      sumneko-lua-language-server
      terraform-ls
      tflint
      nodePackages.bash-language-server
      nodePackages.yaml-language-server
    ];
  };
}
