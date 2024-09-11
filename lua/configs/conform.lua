local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    go = {
      "gofumpt",
      "goimports-reviser",
      "golines",
    },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
