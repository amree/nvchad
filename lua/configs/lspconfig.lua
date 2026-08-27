local configs = require("nvchad.configs.lspconfig")

-- Add folding capabilities for nvim-ufo
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}
configs.capabilities = vim.tbl_deep_extend("force", configs.capabilities, capabilities)

-- Set global LSP defaults for all servers
vim.lsp.config("*", {
	on_init = configs.on_init,
	on_attach = configs.on_attach,
	capabilities = configs.capabilities,
})

-- bundle/ruby must run from root_dir, not Neovim's global cwd, or they
-- resolve the wrong Gemfile/ruby version when a file is opened while cwd
-- points elsewhere. on_new_config is a legacy lspconfig.setup() hook and
-- is never called by vim.lsp.config()/vim.lsp.enable(), so cwd has to be
-- pinned via a cmd function instead (see nvim-lspconfig's lsp/ruby_lsp.lua).
--
-- Call the mise shims (~/.local/share/mise/shims/{ruby,bundle,...}) directly
-- rather than through `mise exec --`; the shims resolve the right version
-- from the spawned process's own cwd.
--
-- mason.nvim prepends its own bin dir to PATH inside Neovim. Mason installs
-- its own rubocop/standardrb (pinned to whatever Ruby was active on install
-- day), and `bundle exec rubocop` resolves the executable via PATH, so it
-- was finding Mason's copy before the project's bundled gem and running it
-- under the wrong Ruby -> Bundler::RubyVersionMismatch. Strip mason/bin from
-- PATH for these spawns so `bundle exec` finds the mise-managed/bundled one.
local mason_bin = vim.fn.stdpath "data" .. "/mason/bin"
local clean_env = vim.fn.environ()
clean_env.PATH = table.concat(
	vim.tbl_filter(function(p)
		return p ~= mason_bin
	end, vim.split(clean_env.PATH or "", ":", { plain = true })),
	":"
)

local function shim_cmd(args)
	return function(dispatchers, config)
		return vim.lsp.rpc.start(
			args,
			dispatchers,
			config and config.root_dir and { cwd = config.root_dir, env = clean_env }
		)
	end
end

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
	herb_ls = {},
	html = {},
	elixirls = {
		cmd = { "elixir-ls" },
		root_markers = { "mix.exs", ".git" },
	},
	ruby_lsp = {
		cmd = shim_cmd({ "ruby-lsp" }),
	},
	-- stimulus_ls = {},
	-- ts_ls = {}, -- Disabled: typescript-tools.nvim replaces ts_ls
	pyright = {},
	-- Emmet support for HTML/CSS/React
	emmet_language_server = {
		filetypes = {
			"html",
			"css",
			"scss",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
		},
	},
	-- TailwindCSS support
	tailwindcss = {
		root_markers = { "tailwind.config.js", "tailwind.config.ts", "tailwind.config.cjs", "tailwind.config.mjs" },
		filetypes = {
			"html",
			"css",
			"scss",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
		},
	},
}

-- Detect Ruby linter based on project config files
local has_standardrb = vim.fn.filereadable(vim.fn.getcwd() .. "/.standard.yml") == 1
local has_rubocop = vim.fn.filereadable(vim.fn.getcwd() .. "/.rubocop.yml") == 1

if has_standardrb then
	servers.standardrb = {
		cmd = shim_cmd({ "bundle", "exec", "standardrb", "--lsp" }),
		root_markers = { ".standard.yml", "Gemfile", ".git" },
	}
elseif has_rubocop then
	servers.rubocop = {
		cmd = shim_cmd({ "bundle", "exec", "rubocop", "--lsp" }),
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
