return {
  'nvim-treesitter/nvim-treesitter',
  cmd = {"TSInstall","TSInstallInfo", "TSUpdate"},
  dependencies = {'p00f/nvim-ts-rainbow'},
  event = "BufRead",
  config = function()
    if pcall(require, 'nvim-treesitter') then
      require('treesitter')
    end
  end
}
