-- https://github.com/wrightbradley/lzvim/commit/122804a607d960a58dd615e8a2551dfefd05e9d5
return {
  {
    "mrjosh/helm-ls",
    dependencies = { -- optional packages
      "towolf/vim-helm",
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        helm_ls = {},
      },
    },
  },
}
