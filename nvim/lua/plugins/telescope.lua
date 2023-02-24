return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    'telescope.nvim',
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
  end
}
