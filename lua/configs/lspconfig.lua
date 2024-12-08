local configs = require("nvchad.configs.lspconfig")
local util = require("lspconfig.util")

local function is_ruby_version_3_or_above()
	local ruby_version_path = vim.fn.getcwd() .. "/.ruby-version"
	if vim.fn.filereadable(ruby_version_path) == 0 then
		return false
	end

	local file = io.open(ruby_version_path, "r")
	if not file then
		return false
	end

	local version = file:read("*line")
	file:close()

	if version then
		-- Remove any prefix (like 'ruby-' or 'jruby-')
		version = version:gsub("^%w+%-", "")
		-- Extract the major version number
		local major_version = tonumber(version:match("^(%d+)"))
		return major_version and major_version >= 3
	end

	return false
end

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
				gofumpt = true,
			},
		},
	},
	html = {},
	-- rubocop = {},
	ruby_lsp = {
		-- TODO: Figure out how to do itwithout executing a shell command
		-- zsh -c "source ~/.zshrc && chruby $(cat .ruby-version) && ruby-lsp"
		-- cmd = { "/usr/local/bin/rubylsp" },
	},
	-- standardrb = {},
	ts_ls = {},
	-- taplo = {},
	-- enable for eslint
	eslint = {},
}

for name, opts in pairs(servers) do
	opts.on_init = configs.on_init
	opts.on_attach = configs.on_attach
	opts.capabilities = configs.capabilities

	require("lspconfig")[name].setup(opts)
end
