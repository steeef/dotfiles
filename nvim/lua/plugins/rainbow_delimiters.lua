local colors = require('dracula').colors()

vim.api.nvim_set_hl(0, 'DraculaPink',    {fg = colors.pink})
vim.api.nvim_set_hl(0, 'DraculaOrange', {fg = colors.orange})
vim.api.nvim_set_hl(0, 'DraculaYellow',   {fg = colors.yellow})
vim.api.nvim_set_hl(0, 'DraculaGreen', {fg = colors.green})
vim.api.nvim_set_hl(0, 'DraculaCyan',  {fg = colors.cyan})
vim.api.nvim_set_hl(0, 'DraculaPurple',  {fg = colors.purple})
vim.api.nvim_set_hl(0, 'DraculaRed',  {fg = colors.red})

return {
  "HiPhish/rainbow-delimiters.nvim",
  event = "VeryLazy",
  config = function()
    local rainbow_delimiters = require("rainbow-delimiters")
    vim.g.rainbow_delimiters = {
      strategy = {
        [""] = rainbow_delimiters.strategy["global"],
        vim = rainbow_delimiters.strategy["local"],
      },
      query = {
        [""] = "rainbow-delimiters",
        lua = "rainbow-blocks",
      },
      highlight = {
        'DraculaPink',
        'DraculaOrange',
        'DraculaYellow',
        'DraculaGreen',
        'DraculaCyan',
        'DraculaPurple',
        'DraculaRed',
      },
    }
  end,
}
