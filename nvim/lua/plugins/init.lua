return {
  { "folke/lazy.nvim", tag = "stable" },
  'andymass/vim-matchup', -- match if/endif etc
  'tpope/vim-surround', -- surround characters shortcuts
  {
    'tpope/vim-sleuth', -- discover appropriate tab settings
    lazy = true,
    event = { 'BufNewFile', 'BufReadPost' },
  },
  'tpope/vim-repeat', -- add . functionality to plugins
  'tpope/vim-unimpaired', -- pairs of handy bracket mappings
  'junegunn/vim-easy-align', -- easily align by character

  -- lua utilities
  {
    'nvim-lua/plenary.nvim',
    cmd = { "PlenaryBustedFile", "PlenaryBustedDirectory" },
    lazy = true
  },

  -- colorschemes
  {
    'Mofiqul/dracula.nvim',
    lazy = false,
    priority = 1000,
  },

  'christoomey/vim-tmux-navigator', -- easier navigation between windows and terminals with tmux

  -- git
  {
    'jreybert/vimagit',
    cmd = 'Magit',
    lazy = true,
  },
  {
    'TimUntersberger/neogit',
    dependencies = {
      'plenary.nvim'
    },
    config = true,
    lazy = true,
    cmd = 'Neogit',
  },

  -- languages
  {
    'numToStr/Comment.nvim', -- aid commenting
    config = true,
    lazy = true,
    event = { 'BufNewFile', 'BufReadPost' },
  },
  'RRethy/vim-illuminate', -- highlight other occurrences of word under cursor
  'towolf/vim-helm',

  -- windows
  {
    'nvim-lua/popup.nvim',
    lazy = true,
  },
  'camspiers/lens.vim', -- resize windows automatically when switching
  'blueyed/vim-diminactive', -- dim inactive windows
}
