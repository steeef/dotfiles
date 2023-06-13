local lsp_plugins = {
  {
    'neovim/nvim-lspconfig',
    lazy = true,
    event = { "BufNewFile", "BufReadPost" },
    config = function()
      local lsp = require('lspconfig')

      lsp.bashls.setup {}
      lsp.lua_ls.setup {}
      lsp.marksman.setup {}
      lsp.nil_ls.setup {}
      lsp.terraformls.setup {}
      lsp.yamlls.setup {
        settings = {
          redhat = {
            telemetry = {
              enabled = false
            }
          },
          yaml = {
            keyOrdering = false
          }
        }
      }
    end
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    lazy = true,
    event = 'InsertEnter',
    config = function()
      local null_ls = require('null-ls')
      null_ls.setup({
        debug = true,
        sources = {
          null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.code_actions.shellcheck,
          null_ls.builtins.code_actions.statix,
          null_ls.builtins.diagnostics.actionlint,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.nixpkgs_fmt,
          null_ls.builtins.formatting.reorder_python_imports,
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.formatting.terraform_fmt,
        },
        -- you can reuse a shared lspconfig on_attach callback here
        on_attach = function(client, bufnr)
          -- short-circuit helm template files
          if vim.bo.filetype == 'helm' then
            vim.diagnostic.disable(bufnr)
            vim.defer_fn(function()
              vim.diagnostic.reset(nil, bufnr)
            end, 1000)
          end
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({
                  filter = function(client)
                    -- apply whatever logic you want (in this example, we'll only use null-ls)
                    return client.name == "null-ls"
                  end,
                  bufnr = bufnr,
                })
              end,
            })
          end
        end,
      })
    end
  },
}

return lsp_plugins
