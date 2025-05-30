return {
  "HiPhish/rainbow-delimiters.nvim",
  event = "VeryLazy",
  submodules = false,
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
    }
  end,
}
