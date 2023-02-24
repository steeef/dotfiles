return {
  'nvim-lualine/lualine.nvim',
  dependencies = {'kyazdani42/nvim-web-devicons'},
  config = function()
    require('lualine').setup {
      options = { theme = 'dracula-nvim' }
    }
  end,
  event = 'VeryLazy',
}
