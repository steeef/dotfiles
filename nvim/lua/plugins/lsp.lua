local lsps = {
  "bashls",
  "jsonls",
  "lua_ls",
  "marksman",
  "pyright",
  "terraformls",
  "tflint",
  "yamlls",
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local lsp_plugins = {
  {
    'neovim/nvim-lspconfig',
    lazy = true,
    dependencies = { 'mason-lspconfig.nvim' },
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'mason.nvim' },
    cmd = { 'LspInstall', 'LspUninstall' },
    event = { 'BufNewFile', 'BufReadPost' },
    lazy = true,
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        ensure_installed = lsps
      })
      mason_lspconfig.setup_handlers({
        function (server_name)
          require("lspconfig")[server_name].setup {}
        end
      })
      require("lspconfig").nil_ls.setup{}
    end,
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
          null_ls.builtins.formatting.rome,
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.formatting.terraform_fmt,
        },
        -- you can reuse a shared lspconfig on_attach callback here
        on_attach = function(client, bufnr)
          -- short-circuit helm template files
          if client.config.name == 'yamlls' and vim.bo.filetype == 'helm' then
              vim.lsp.buf_detach_client(bufnr, client.id)
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
  {
    'williamboman/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUninstallAll', 'MasonLog' },
    lazy = true,
    config = function()
      require('mason').setup()
    end
  },
}

return lsp_plugins
