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
    if pcall(require, 'cmp') then
      require('autocompletion')
    end
  end
}
