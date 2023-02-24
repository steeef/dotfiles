#!/bin/bash

# Installs/updates addons for Neovim

printf "\nUpdating plugins with lazy.nvim\n"
"${HOME}/bin/nvim" --headless \
  "+Lazy! sync" \
  +messages +qa
printf "\nUpdating Treesitter modules\n"
"${HOME}/bin/nvim" --headless \
  +TSUpdateSync \
  +messages +qa
printf "\nUpdating LSP modules\n"
"${HOME}/bin/nvim" --headless \
  -c 'autocmd User MasonToolsUpdateCompleted quitall' -c 'MasonToolsUpdate' \
  +messages
printf "\n"
