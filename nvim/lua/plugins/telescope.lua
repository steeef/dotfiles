return {
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
}
