local lsp_installer = require('nvim-lsp-installer')

lsp_installer.setup {}

-- specific to terraform-ls
vim.cmd [[ autocmd BufWritePre *.tf lua vim.lsp.buf.formatting() ]]
