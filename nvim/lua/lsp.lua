local lspconfig = require('lspconfig')

local servers = {
  'pyright',
  'terraformls',
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = lsp_capabilities,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
