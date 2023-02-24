return {
  'hrsh7th/nvim-cmp', -- completion
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'f3fora/cmp-spell',
  },
  config = function()
    local cmp = require('cmp')
    cmp.setup({
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
      }, {
          { name = 'buffer' },
        }, {
          { name = 'spell',
            option = {
              enable_in_context = function()
                return true
              end
            }
          },
        }
      );

      mapping = {
        ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      }
    })

    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline('/', {
      sources = {
        { name = 'buffer' }
      }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      sources = cmp.config.sources({
        {
          name = 'path' }
        },
        {
          { name = 'cmdline' }
        });

      mapping = {
        ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Command }),
      }
    })
  end
}
