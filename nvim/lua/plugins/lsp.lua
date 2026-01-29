return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
        helm_ls = {},
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
        markdown_oxide = {},
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
    "mfussenegger/nvim-lint",
    opts = {
      -- Event to trigger linters
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        bash = { "shellcheck" },
        python = { "ruff" },
        sh = { "shellcheck" },
        zsh = { "shellcheck" },
      },
      -- LazyVim extension to easily override linter options
      -- or add custom linters.
      ---@type table<string,table>
      linters = {
        -- -- Example of using selene only when a selene.toml file is present
        -- selene = {
        --   -- `condition` is another LazyVim extension that allows you to
        --   -- dynamically enable/disable linters based on the context.
        --   condition = function(ctx)
        --     return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
        --   end,
        -- },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        nix = { "alejandra" },
        python = { "black", "reorder_python_imports" },
        yaml = { "yamlfmt" },
        bash = { "shfmt" },
        sh = { "shfmt" },
        zsh = { "shfmt" },
      },
    },
  },
}
