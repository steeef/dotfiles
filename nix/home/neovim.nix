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

    plugins = with pkgs.unstable.vimPlugins; [
      lazy-nvim

      (nvim-treesitter.withPlugins (
        plugins: with plugins; [
          bash
          c
          css
          go
          hcl
          html
          java
          json
          lua
          make
          markdown
          markdown_inline
          nix
          python
          rust
          toml
          tsx
          typescript
          vim
          yaml
        ]
      ))
    ];
  };
  home.file."./.config/nvim/".source = ./config;
}
