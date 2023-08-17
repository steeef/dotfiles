return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
        jsonls = {},
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
        marksman = {},
        nil_ls = {},
        yamlls = {
          settings = {
            redhat = {
              telemetry = {
                enabled = false,
              },
            },
            yaml = {
              keyOrdering = false,
            },
          },
        },
      },
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = vim.list_extend(opts.sources, {
        nls.builtins.formatting.black,
      })
    end,
  }
}
