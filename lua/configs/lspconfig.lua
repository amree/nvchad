local configs = require("nvchad.configs.lspconfig")
local util = require("lspconfig.util")

local servers = {
	cssls = {},
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
			},
		},
	},
	html = {},
	ruby_lsp = {
		-- TODO: Figure out how to do itwithout executing a shell command
		-- zsh -c "source ~/.zshrc && chruby $(cat .ruby-version) && ruby-lsp"
		cmd = { "/usr/local/bin/rubylsp" },
	},
}

for name, opts in pairs(servers) do
	opts.on_init = configs.on_init
	opts.on_attach = configs.on_attach
	opts.capabilities = configs.capabilities

	require("lspconfig")[name].setup(opts)
end
