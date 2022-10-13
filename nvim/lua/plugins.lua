-- plugins with packer
require('packer').startup(function()
  use {'wbthomason/packer.nvim'}

  use {'andymass/vim-matchup'} -- match if/endif etc
  use {'tpope/vim-surround'} -- surround characters shortcuts
  use {'tpope/vim-repeat'} -- add . functionality to plugins
  use {'tpope/vim-unimpaired'} -- pairs of handy bracket mappings
  use {'junegunn/vim-easy-align'} -- easily align by character
  use {
    'windwp/nvim-autopairs', -- bracket pairs
    config = function()
      if pcall(require, 'nvim-autopairs') then
        require('autopairs')
      end
    end
  }

  -- colorschemes
  use {'RRethy/nvim-base16'}
  use {'navarasu/onedark.nvim'}
  use {'Mofiqul/dracula.nvim'}

  use {
    'nvim-lualine/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
      if pcall(require, 'lualine') then
        require('lualine').setup {
          options = { theme = 'dracula-nvim' }
        }
      end
    end
  }

  use {'christoomey/vim-tmux-navigator'} -- easier navigation between windows and terminals with tmux

  -- git
  use {'jreybert/vimagit'}
  use { 'lewis6991/gitsigns.nvim', -- git added/removed in sidebar + inline blame
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      if pcall(require, 'gitsigns') then
        require('gitsigns').setup({
          current_line_blame = false
        })
      end
    end
  }

  -- languages
  use {'tpope/vim-commentary'} -- commenting helper
  use {
    'monkoose/matchparen.nvim',
    config = function()
      if pcall(require, 'matchparen') then
        require ('matchparen')
      end
    end
  }
  use {'RRethy/vim-illuminate'} -- highlight other occurrences of word under cursor
  use { 'williamboman/nvim-lsp-installer' }
  use {
    'hrsh7th/nvim-cmp', -- completion
    requires = {
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'hrsh7th/cmp-cmdline'},
    },
    config = function()
      if pcall(require, 'cmp') then
        require('autocompletion')
      end
    end
  }
  use {
    'neovim/nvim-lspconfig',
    config = function()
      if pcall(require, 'lspconfig') then
        require('lsp')
      end
    end
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    cmd = {"TSInstall","TSInstallInfo", "TSUpdate"},
    event = "BufRead",
    after = "telescope.nvim",
    config = function()
      if pcall(require, 'nvim-treesitter') then
        require('treesitter')
      end
    end
  }
  use { 'p00f/nvim-ts-rainbow',  -- rainbow parenthesis
    after = 'nvim-treesitter',
  }
  -- neomake for linters
  use { 'neomake/neomake', config = function() require('neomake_conf') end }

  -- windows
  use {'camspiers/lens.vim'} -- resize windows automatically when switching
  use {'blueyed/vim-diminactive'} -- dim inactive windows
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'}
    },
    config = function()
      if pcall(require, 'telescope') then
        require('telescope-config')
      end
    end
  }
end)
