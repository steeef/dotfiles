return {
  {
    'neovim/nvim-lspconfig',
    lazy = true,
    dependencies = { 'mason-lspconfig.nvim', 'nlsp-settings.nvim' },
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'mason.nvim' },
    cmd = { 'LspInstall', 'LspUninstall' },
    lazy = true,
    config = function()
      mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        ensure_installed = {
          "bash-language-server",
          "black",
          "lua-language-server",
          "markdownlint",
          "marksman",
          "pyright",
          "reorder-python-imports",
          "rome",
          "shellcheck",
          "shfmt",
          "terraform-ls",
          "tflint",
          "yaml-language-server",
          "yamllint",
        }
      })
      mason_lspconfig.setup_handlers({
        function (server_name)
          require("lspconfig")[server_name].setup {
            on_attach = require("shared").on_attach,
          }
        end
      })
    end,
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    lazy = true,
    config = function()
      local null_ls = require('null-ls')
      null_ls.setup({
        sources = {
          null_ls.builtins.code_actions.shellcheck,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.reorder_python_imports,
          null_ls.builtins.formatting.rome,
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.formatting.terraform_fmt,
        },
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
