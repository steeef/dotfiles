return {
  'folke/which-key.nvim', -- popup helper for commands
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    require("which-key").setup()
  end,
  lazy = false,
}
