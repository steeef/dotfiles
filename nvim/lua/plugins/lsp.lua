return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    dependencies = {
      -- LSP Support
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    }
  },
  {
    'williamboman/mason.nvim',
    lazy = true,
    config = function()
      require('mason').setup()
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    lazy = true,
    config = function()
      require('mason-lspconfig').setup()
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
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'williamboman/mason-lspconfig.nvim' },
    event = { 'BufReadPre', 'BufNewFile' },
  }
}
