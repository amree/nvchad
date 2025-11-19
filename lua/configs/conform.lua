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
		-- Hybrid approach: Only apply default indent settings if biome.json doesn't specify them
		["biome-check"] = {
			command = util.from_node_modules("biome"),
			args = function(self, ctx)
				local base_args = { "check", "--write", "--unsafe" }

				-- Check if biome.json or biome.jsonc exists and has formatter config
				local biome_config_path = vim.fs.root(ctx.dirname, { "biome.json", "biome.jsonc" })
				local has_formatter_config = false

				if biome_config_path then
					local config_files = { "biome.json", "biome.jsonc" }
					for _, config_file in ipairs(config_files) do
						local config_path = biome_config_path .. "/" .. config_file
						if vim.fn.filereadable(config_path) == 1 then
							local content = vim.fn.readfile(config_path)
							local json_str = table.concat(content, "\n")
							-- Check if formatter.indentStyle or formatter.indentWidth is defined
							if json_str:match('"formatter"%s*:%s*{') and json_str:match('"indent') then
								has_formatter_config = true
								break
							end
						end
					end
				end

				-- Only add default indent args if biome.json doesn't specify formatter settings
				if not has_formatter_config then
					table.insert(base_args, "--indent-style=space")
					table.insert(base_args, "--indent-width=2")
				end

				table.insert(base_args, "--stdin-file-path")
				table.insert(base_args, "$FILENAME")

				return base_args
			end,
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
