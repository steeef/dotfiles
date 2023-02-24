return {
  'windwp/nvim-autopairs', -- bracket pairs
  config = function()
    if pcall(require, 'nvim-autopairs') then
      require('autopairs')
    end
  end
}
