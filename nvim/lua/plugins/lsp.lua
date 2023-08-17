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
                enabled = false
              }
            },
            yaml = {
              keyOrdering = false
            }
          },
        },
      }
    }
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      table.insert(opts.sources, nls.builtins.formatting.black)
      table.insert(opts.sources, nls.code_actions.gitsigns)
      table.insert(opts.sources, nls.code_actions.shellcheck)
      table.insert(opts.sources, nls.code_actions.statix)
      table.insert(opts.sources, nls.diagnostics.actionlint)
      table.insert(opts.sources, nls.formatting.black)
      table.insert(opts.sources, nls.formatting.nixpkgs_fmt)
      table.insert(opts.sources, nls.formatting.reorder_python_imports)
      table.insert(opts.sources, nls.formatting.shfmt)
    end,
  }
}
