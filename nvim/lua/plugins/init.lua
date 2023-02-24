return {
  'andymass/vim-matchup', -- match if/endif etc
  'tpope/vim-surround', -- surround characters shortcuts
  'tpope/vim-repeat', -- add . functionality to plugins
  'tpope/vim-unimpaired', -- pairs of handy bracket mappings
  'junegunn/vim-easy-align', -- easily align by character

  -- colorschemes
  'Mofiqul/dracula.nvim',

  'christoomey/vim-tmux-navigator', -- easier navigation between windows and terminals with tmux

  -- git
  'jreybert/vimagit',

  -- languages
  'tpope/vim-commentary', -- commenting helper
  'mhartington/formatter.nvim', -- automatically format specific filetypes
  'RRethy/vim-illuminate', -- highlight other occurrences of word under cursor
  'towolf/vim-helm', -- commenting helper

  -- lsp
  {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'neovim/nvim-lspconfig',
  },

  -- neomake for linters
  {'neomake/neomake', config = function() require('neomake_conf') end},

  -- windows
  'camspiers/lens.vim', -- resize windows automatically when switching
  'blueyed/vim-diminactive', -- dim inactive windows
  {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
}
