local configs = require("nvchad.configs.lspconfig")

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

-- Detect Ruby linter based on project config files
local has_standardrb = vim.fn.filereadable(vim.fn.getcwd() .. "/.standard.yml") == 1
local has_rubocop = vim.fn.filereadable(vim.fn.getcwd() .. "/.rubocop.yml") == 1

if has_standardrb then
	servers.standardrb = {
		cmd = { "bundle", "exec", "standardrb", "--lsp" },
		root_markers = { ".standard.yml", "Gemfile", ".git" },
	}
elseif has_rubocop then
	servers.rubocop = {
		cmd = { "bundle", "exec", "rubocop", "--lsp" },
		root_markers = { ".rubocop.yml", "Gemfile", ".git" },
	}
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
