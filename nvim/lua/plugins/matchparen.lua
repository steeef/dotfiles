return {
  'monkoose/matchparen.nvim',
  config = function()
    require('matchparen').setup({
      on_startup = true, -- Should it be enabled by default
    })
  end
}
