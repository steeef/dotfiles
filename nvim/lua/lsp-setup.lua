vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
  if err ~= nil or result == nil then
    return
  end

  -- Short-circuit for Helm template files
  if vim.bo[bufnr].buftype ~= '' or vim.bo[bufnr].filetype == 'helm' then
    require('user').diagnostic.disable(bufnr)
    return
  end

  if not vim.api.nvim_buf_get_option(bufnr, "modified") then
    local view = vim.fn.winsaveview()
    vim.lsp.util.apply_text_edits(result, bufnr)
    vim.fn.winrestview(view)
    if bufnr == vim.api.nvim_get_current_buf() then
      vim.api.nvim_command("noautocmd :update")
    end
  end
end

local mason_installed, mason = pcall(require, "mason")
if mason_installed then
  mason.setup()
end

local mason_tool_installer_installed, mason_tool_installer = pcall(require, "mason-tool-installer")
if mason_tool_installer_installed then
  mason_tool_installer.setup{
  }
end

local mason_lspconfig_installed, mason_lspconfig = pcall(require, "mason-lspconfig")
if mason_lspconfig_installed then
  mason_lspconfig.setup()

  local lspconfig_installed, lsp = pcall(require, "lspconfig")
  if lspconfig_installed then
    mason_lspconfig.setup_handlers{
      function(server)
        lsp[server].setup({})
      end
    }
  end
end
