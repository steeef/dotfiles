local lspconfig = require('lspconfig')
local servers = require('lspinstall').installed_servers()
local lsp_capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

for _, server in pairs(servers) do
  lspconfig[server].setup {
    capabilities = lsp_capabilities,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
