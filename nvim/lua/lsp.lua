local lsp_installer = require('nvim-lsp-installer')

lsp_installer.setup {}

-- specific to terraform-ls
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.tf",
    callback = function(args)
        vim.lsp.buf.formatting()
    end
})
