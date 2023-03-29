return {
  {
    'hrsh7th/nvim-cmp', -- completion
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'f3fora/cmp-spell',
      {
        "zbirenbaum/copilot-cmp",
        dependencies = "copilot.lua",
        opts = {},
        config = function(_, opts)
          local copilot_cmp = require("copilot_cmp")
          copilot_cmp.setup(opts)
          -- attach cmp source whenever copilot attaches
          -- fixes lazy-loading issues with the copilot cmp source
          require("util").on_attach(function(client)
            if client.name == "copilot" then
              copilot_cmp._on_insert_enter()
            end
          end)
        end,
      },

    },
    opts = function(_, opts)
      local cmp = require('cmp')
      opts.sources = cmp.config.sources({
        { name = 'copilot' },
        { name = 'nvim_lsp' },
      },
      {
        { name = 'buffer' },
      },
      {
        { name = 'spell',
          option = {
            enable_in_context = function()
              return true
            end
          }
        },
      })
      opts.mapping = {
        ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      }
    end,
    config = function(_, opts)
      local cmp = require('cmp')
      cmp.setup(opts)
      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline('/', {
        sources = {
          { name = 'buffer' }
        }
      })
      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        sources = cmp.config.sources(
          { { name = 'path' } },
          { { name = 'cmdline' } }
        );
        mapping = {
          ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Command }),
        }
      })
    end,
  },
}
