-- plugins with packer
require('packer').startup(function()
  use {'wbthomason/packer.nvim'}

  use {'chriskempson/base16-vim'}

  use {'christoomey/vim-tmux-navigator'}

  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

  --- use lens.vim to resize windows automatically when switched
  use {'camspiers/lens.vim'}

  --- dim inactive windows
  use {'blueyed/vim-diminactive'}
end)

--- tree-sitter bootstrap and update
if pcall(require, 'nvim-treesitter') then
  require('nvim-treesitter.configs').setup {
    ensure_installed = 'maintained',
    highlight = {enable = true},
  }
end
