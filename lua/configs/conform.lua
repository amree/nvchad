local options = {
	formatters_by_ft = {
		go = {
			"gofumpt",
			"goimports-reviser",
			"golines",
		},
		lua = { "stylua" },
	},

	format_on_save = {
		timeout_ms = 2500,
		lsp_fallback = true,
	},
}

return options
