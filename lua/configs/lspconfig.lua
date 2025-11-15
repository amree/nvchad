local configs = require("nvchad.configs.lspconfig")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

-- Set global LSP defaults for all servers
vim.lsp.config("*", {
	on_init = configs.on_init,
	on_attach = configs.on_attach,
	capabilities = configs.capabilities,
})

local servers = {
	cssls = {},
	eslint = {},
	gopls = {
		cmd = { "gopls" },
		filetypes = { "go", "gomod", "gotmpl" },
		root_markers = { "go.mod", ".git" },
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

if project_name == "petakopi.my" then
	servers.standardrb = {}
elseif project_name == "coinanalytics" then
	-- servers.rubocop = {}
end

-- Configure and enable each LSP server
for name, opts in pairs(servers) do
	if next(opts) ~= nil then
		-- If server has custom config, apply it
		vim.lsp.config(name, opts)
	end
	-- Enable the server
	vim.lsp.enable(name)
end
