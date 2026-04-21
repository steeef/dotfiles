{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    withNodeJs = true;
    withRuby = false;
    withPython3 = false;
    initLua = builtins.readFile ../../nvim/init.lua;

    extraPackages = with pkgs; [
      actionlint
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
      bash-language-server
      yaml-language-server
      vscode-langservers-extracted
    ];
  };
}
