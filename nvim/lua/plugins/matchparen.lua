return {
  'monkoose/matchparen.nvim',
  config = function()
    if pcall(require, 'matchparen') then
      require ('matchparen')
    end
  end
}
