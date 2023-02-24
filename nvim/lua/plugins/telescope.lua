return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'telescope-fzf-native.nvim',
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
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    lazy = true,
  },
}
