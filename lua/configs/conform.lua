local util = require("conform.util")

-- Auto-detect formatter based on project config files
-- Only format if project explicitly has Biome or Prettier config
local function js_formatter(bufnr)
	-- Handle case where bufnr might be nil (e.g., when called from :ConformInfo)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	-- Get the directory of the current buffer
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	local dirname = vim.fn.fnamemodify(bufname, ":p:h")

	-- Check for Biome config
	local has_biome = vim.fs.root(dirname, { "biome.json", "biome.jsonc" })

	-- Check for Prettier config
	local has_prettier = vim.fs.root(dirname, {
		".prettierrc",
		".prettierrc.json",
		".prettierrc.yml",
		".prettierrc.yaml",
		".prettierrc.json5",
		".prettierrc.js",
		".prettierrc.cjs",
		".prettierrc.mjs",
		".prettierrc.toml",
		"prettier.config.js",
		"prettier.config.cjs",
		"prettier.config.mjs",
	})

	if has_biome then
		return { "biome-check" }
	elseif has_prettier then
		return { "prettier" }
	else
		-- No formatter config found, don't format
		return {}
	end
end

local options = {
	formatters_by_ft = {
		-- Go
		go = {
			"gofumpt",
			"goimports",
			"goimports-reviser",
			"golines",
		},
		-- Lua
		lua = { "stylua" },
		-- JavaScript/TypeScript (auto-detect Biome or Prettier)
		javascript = js_formatter,
		typescript = js_formatter,
		javascriptreact = js_formatter,
		typescriptreact = js_formatter,
		-- JSON (auto-detect Biome or Prettier)
		json = js_formatter,
		jsonc = js_formatter,
		-- CSS/HTML/Markdown (Biome doesn't support, use Prettier)
		css = { "prettier" },
		scss = { "prettier" },
		html = { "prettier" },
		markdown = { "prettier" },
		yaml = { "prettier" },
	},

	formatters = {
		-- Custom biome-check that runs format + lint with unsafe fixes
		-- This removes unused imports without renaming variables (via biome.json config)
		["biome-check"] = {
			command = util.from_node_modules("biome"),
			args = { "check", "--write", "--unsafe", "--stdin-file-path", "$FILENAME" },
			stdin = true,
			cwd = util.root_file({
				"biome.json",
				"biome.jsonc",
			}),
		},
	},

	format_on_save = {
		timeout_ms = 2500,
		lsp_fallback = true,
	},
}

return options
