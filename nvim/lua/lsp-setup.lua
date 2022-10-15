local servers = {
  "bashls",
}

local mason_installed, mason = pcall(require, "mason")
if mason_installed then
  mason.setup()
end

local mason_lspconfig_installed, mason_lspconfig = pcall(require, "mason-lspconfig")
if mason_lspconfig_installed then
  mason_lspconfig.setup()
end

local mason_tool_installer_installed, mason_tool_installer = pcall(require, "mason-tool-installer")
if mason_tool_installer_installed then
  mason_tool_installer.setup{
    ensure_installed = {
      "bash-language-server",
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
  }
end

local lspconfig_installed, lspconfig = pcall(require, "lspconfig")
if lspconfig_installed then
  for server, _ in pairs(servers) do
    lspconfig[server].setup()
  end
end
