#!/bin/bash

# Installs/updates addons for Neovim

echo "Updating plugins with Packer"
"${HOME}/bin/nvim" --headless \
  +PackerSync +PackerCompile \
  +messages +qa
echo
echo "Updating Treesitter modules"
"${HOME}/bin/nvim" --headless \
  +"PackerLoad nvim-treesitter" \
  +TSUpdateSync \
  +messages +qa
