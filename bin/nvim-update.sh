#!/bin/bash

# Installs/updates addons for Neovim

echo "Updating plugins with Packer"
"${HOME}/bin/nvim" --headless \
  +PackerSync +PackerCompile \
  +"PackerLoad nvim-treesitter" +TSUpdateSync \
  +"PackerLoad nvim-lsp-installer" \
  +"LspInstall --sync bashls pyright terraformls yamlls" \
  +messages +quit
