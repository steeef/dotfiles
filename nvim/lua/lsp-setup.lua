local mason_installed, mason = pcall(require, "mason")
if mason_installed then
  mason.setup()
end

local mason_tool_installer_installed, mason_tool_installer = pcall(require, "mason-tool-installer")
if mason_tool_installer_installed then
  mason_tool_installer.setup{
    ensure_installed = {
      "bash-language-server",
      "black",
      "isort",
      "lua-language-server",
      "marksman",
      "pyright",
      "shellcheck",
      "shfmt",
      "terraform-ls",
      "tflint",
      "yaml-language-server",
      "yamllint",
    },
    automatic_installation = true,
    auto_update = false,
    run_on_start = true,
  }
end

local mason_lspconfig_installed, mason_lspconfig = pcall(require, "mason-lspconfig")
if mason_lspconfig_installed then
  mason_lspconfig.setup{
    ensure_installed = {
      "bashls",
      "jsonls",
      "pyright",
      "sumneko_lua",
      "terraform-ls",
      "yamlls",
    },
    automatic_installation = true,
  }

  local lspconfig_installed, lsp = pcall(require, "lspconfig")
  if lspconfig_installed then
    mason_lspconfig.setup_handlers{
      function(server)
        lsp[server].setup({})
      end,
    }
  end
end
