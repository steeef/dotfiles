return {
  {
    'TimUntersberger/neogit',
    dependencies = {
      'plenary.nvim'
    },
    opts = {
      disable_signs = false,
      disable_context_highlighting = false,
      disable_commit_confirmation = true,
      kind = 'vsplit',
    },
    lazy = true,
    cmd = 'Neogit',
    keys = {
      { "<leader>g", ":Neogit<Enter>" }
    }
  },
}
