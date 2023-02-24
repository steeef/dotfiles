return {
  'andymass/vim-matchup', -- match if/endif etc
  'tpope/vim-surround', -- surround characters shortcuts
  'tpope/vim-repeat', -- add . functionality to plugins
  'tpope/vim-unimpaired', -- pairs of handy bracket mappings
  'junegunn/vim-easy-align', -- easily align by character
  {
    'windwp/nvim-autopairs', -- bracket pairs
    config = function()
      if pcall(require, 'nvim-autopairs') then
        require('autopairs')
      end
    end
  },

  -- colorschemes
  'Mofiqul/dracula.nvim',

  {
    'nvim-lualine/lualine.nvim',
    dependencies = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
      if pcall(require, 'lualine') then
        require('lualine').setup {
          options = { theme = 'dracula-nvim' }
        }
      end
    end
  },

  'christoomey/vim-tmux-navigator', -- easier navigation between windows and terminals with tmux

  -- git
  'jreybert/vimagit',
  { 'lewis6991/gitsigns.nvim', -- git added/removed in sidebar + inline blame
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      if pcall(require, 'gitsigns') then
        require('gitsigns').setup({
          current_line_blame = false
        })
      end
    end
  },

  -- languages
  'tpope/vim-commentary', -- commenting helper
  {
    'monkoose/matchparen.nvim',
    config = function()
      if pcall(require, 'matchparen') then
        require ('matchparen')
      end
    end
  },
  'mhartington/formatter.nvim', -- automatically format specific filetypes
  'RRethy/vim-illuminate', -- highlight other occurrences of word under cursor

  {
    'cappyzawa/trim.nvim', -- trim trailing whitespace
    config = function()
      if pcall(require, 'trim') then
        require('trim').setup({
          disable = {'markdown'},

          patterns = {
            [[%s/\s\+$//e]],           -- remove unwanted spaces
            [[%s/\($\n\s*\)\+\%$//]],  -- trim last line
          },
        })
      end
    end
  },
  'towolf/vim-helm', -- commenting helper

  -- lsp
  {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'neovim/nvim-lspconfig',
  },

  {
    'hrsh7th/nvim-cmp', -- completion
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'f3fora/cmp-spell',
    },
    config = function()
      if pcall(require, 'cmp') then
        require('autocompletion')
      end
    end
  },
  {
    'nvim-treesitter/nvim-treesitter',
    cmd = {"TSInstall","TSInstallInfo", "TSUpdate"},
    dependencies = {'p00f/nvim-ts-rainbow'},
    event = "BufRead",
    config = function()
      if pcall(require, 'nvim-treesitter') then
        require('treesitter')
      end
    end
  },

  -- neomake for linters
   'neomake/neomake', config = function() require('neomake_conf') end ,

  -- windows
  'camspiers/lens.vim', -- resize windows automatically when switching
  'blueyed/vim-diminactive', -- dim inactive windows
  'nvim-telescope/telescope-fzf-native.nvim', build = 'make' ,
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'telescope.nvim',
    },
    config = function()
      if pcall(require, 'telescope') then
        require('telescope-config')
      end
    end
  },
}
