return {
  'nvim-lualine/lualine.nvim',
  dependencies = {'kyazdani42/nvim-web-devicons', opt = true},
  config = function()
    if pcall(require, 'lualine') then
      require('lualine').setup {
        options = { theme = 'dracula-nvim' }
      }
    end
  end
}
