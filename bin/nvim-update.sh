#!/bin/bash

# Installs/updates addons for Neovim

printf "\nUpdating plugins with Packer\n"
"${HOME}/bin/nvim" --headless \
  +"autocmd User PackerComplete quitall" \
  +PackerSync \
  +messages
printf "\nUpdating Treesitter modules\n"
"${HOME}/bin/nvim" --headless \
  +"PackerLoad nvim-treesitter" \
  +TSUpdateSync \
  +messages +qa
printf "\n"
