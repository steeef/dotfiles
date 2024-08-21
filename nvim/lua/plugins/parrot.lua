return {
  {
    "frankroeder/parrot.nvim",
    dependencies = {
      "ibhagwan/fzf-lua",
      "plenary.nvim",
    },
    opts = {
      disable_signs = false,
      disable_context_highlighting = false,
      disable_commit_confirmation = true,
      kind = "vsplit",
    },
    lazy = false,
    config = function()
      require("parrot").setup({
        providers = {
          anthropic = {
            api_key = { "/usr/bin/security", "find-generic-password", "-s anthropic-api-key", "-w" },
          },
        },
        fzf_lua = {
          winopts = {
            height = 0.5,
            width = 0.5,
            preview = {
              hidden = "hidden",
            },
          },
        },
      })
    end,
  },
}
