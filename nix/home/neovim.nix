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
      tree-sitter
      nodePackages.bash-language-server
      nodePackages.yaml-language-server
    ];

    plugins = with pkgs.vimPlugins; [
      nvim-treesitter
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
          regex
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
}
