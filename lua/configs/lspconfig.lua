local configs = require("nvchad.configs.lspconfig")
local util = require("lspconfig.util")

local servers = {
	cssls = {},
	eslint = {},
	gopls = {
		cmd = { "gopls" },
		filetypes = { "go", "gomod", "gotmpl" },
		root_dir = util.root_pattern("go.mod", ".git"),
		settings = {
			gopls = {
				completeUnimported = true,
				usePlaceholders = true,
				analyses = {
					unusedparams = true,
				},
				gofumpt = true,
			},
		},
	},
	html = {},
	ruby_lsp = {},
	standardrb = {},
	-- rubocop = {},
	-- stimulus_ls = {},
	ts_ls = {
		settings = {
			javascript = {
				validate = {
					enable = true,
					checkJs = false, -- Don't type check .js files as if they were .ts
				},
			},
		},
	},
	pyright = {},
}

for name, opts in pairs(servers) do
	opts.on_init = configs.on_init
	opts.on_attach = configs.on_attach
	opts.capabilities = configs.capabilities

	require("lspconfig")[name].setup(opts)
end
