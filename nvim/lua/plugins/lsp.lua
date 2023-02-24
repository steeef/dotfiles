return {
  {
    'neovim/nvim-lspconfig',
    lazy = true,
    dependencies = { 'mason-lspconfig.nvim', 'nlsp-settings.nvim' },
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'mason.nvim' },
    cmd = { 'LspInstall', 'LspUninstall' }
    lazy = true,
    config = function()
      require('mason-lspconfig').setup()
    end
  },
  {
    'tamago324/nlsp-settings.nvim',
    cmd = 'LspSettings',
    lazy = true
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    lazy = true
  },
  {
    'williamboman/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUninstallAll', 'MasonLog' },
    lazy = true,
    config = function()
      require('mason').setup()
    end
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-tool-installer').setup {
        ensure_installed = {
          "bash-language-server",
          "black",
          "isort",
          "lua-language-server",
          "markdownlint",
          "marksman",
          "pyright",
          "shellcheck",
          "shfmt",
          "terraform-ls",
          "tflint",
          "yaml-language-server",
          "yamllint",
        },
        automatic_installation = true,
        auto_update = false,
        run_on_start = true,
      }
    end
  },
}
