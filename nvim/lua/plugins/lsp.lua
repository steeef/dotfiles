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
          nls.builtins.code_actions.gitsigns,
          nls.builtins.code_actions.shellcheck,
          nls.builtins.code_actions.statix,
          nls.builtins.diagnostics.actionlint,
          nls.builtins.formatting.black,
          nls.builtins.formatting.nixpkgs_fmt,
          nls.builtins.formatting.reorder_python_imports,
          nls.builtins.formatting.shfmt,
      })
    end,
  }
}
