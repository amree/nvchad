require("nvchad.configs.lspconfig").defaults()
local lspconfig = require "lspconfig"
local servers = {
  "cssls",
  "html",
  "ruby_lsp",
}
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- zsh -c "source ~/.zshrc && chruby $(cat .ruby-version) && ruby-lsp"
lspconfig.ruby_lsp.setup {
  cmd = { "/usr/local/bin/rubylsp" },
}
