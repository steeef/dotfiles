-- plugins with packer
require('packer').startup(function()
  use {'wbthomason/packer.nvim'}

  use {'andymass/vim-matchup'}

  -- colorschemes
  use {'chriskempson/base16-vim'}

  use {'christoomey/vim-tmux-navigator'}

  -- git
  use {'jreybert/vimagit'}
  use { 'lewis6991/gitsigns.nvim', -- git added/removed in sidebar + inline blame
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup({
        current_line_blame = false
      })
    end
  }

  -- languages
  use {'tpope/vim-commentary'}
  use {'neovim/nvim-lspconfig'}
  use {'kabouzeid/nvim-lspinstall'}
  use {'hrsh7th/nvim-compe'}
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

  -- windows
  use {'camspiers/lens.vim'} -- resize windows automatically when switching
  use {'blueyed/vim-diminactive'} -- dim inactive windows

  use { 'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}} }
  use {'kyazdani42/nvim-web-devicons'}
end)

--- tree-sitter bootstrap and update
if pcall(require, 'nvim-treesitter') then
  require('nvim-treesitter.configs').setup {
    ensure_installed = 'maintained',
    highlight = {enable = true},
  }
end
