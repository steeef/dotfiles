return {
  'lewis6991/gitsigns.nvim', -- git added/removed in sidebar + inline blame
  dependencies = {'nvim-lua/plenary.nvim'},
  config = function()
    require('gitsigns').setup({
      current_line_blame = false
    })
  end,
  event = 'VeryLazy',
}
