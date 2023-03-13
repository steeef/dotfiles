return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      },
    },
    config = function()
      require('telescope').setup {
        pickers = {
          find_files = {
            hidden = true
          }
        },
        defaults = {
          file_ignore_patterns = { '%.jpg', '%.jpeg', '%.png', '%.otf', '%.ttf', '.git/' },
        },
      }
    end,
    branch = '0.1.x',
    cmd = 'Telescope',
    lazy = true,
  },
}
