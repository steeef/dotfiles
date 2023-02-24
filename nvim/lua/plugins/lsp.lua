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

      -- Autocompletion
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
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
    config = function()
      local lsp = pcall(require, 'lspconfig')
      require('mason-lspconfig').setup_handlers{
        function(server)
          lsp[server].setup({})
        end
      }
    end,
    event = { 'BufReadPre', 'BufNewFile' },
  }
}
