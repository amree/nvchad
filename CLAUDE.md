# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration based on NvChad v2.5. The configuration extends NvChad with custom plugins, LSP servers, and project-specific settings.

## Installation and Setup

The configuration is installed via symbolic link:
```bash
ln -s /Users/amree/Workspaces/Personal/nvchad ~/.config/nvchad
```

## Architecture

### Initialization Flow (init.lua)

The bootstrap sequence follows this order:
1. Set global variables (`base46_cache`, `mapleader = <Space>`)
2. Bootstrap lazy.nvim plugin manager (auto-install if missing)
3. Setup plugins via lazy.nvim (imports NvChad base + custom plugins)
4. Load theme cache files
5. Load custom options (`options.lua`)
6. Load NvChad autocommands
7. Load custom mappings (`mappings.lua`)
8. **Load project-specific `.nvim.lua`** if exists in current working directory

This means `.nvim.lua` files can override any configuration, making them powerful for project-specific customizations.

### File Structure

```
init.lua                          # Main entry point and bootstrapper
lazy-lock.json                    # Plugin version lock file
lua/
├── chadrc.lua                    # NvChad-specific configuration (theme, UI)
├── options.lua                   # Vim options (extends nvchad.options)
├── mappings.lua                  # Custom key mappings (extends nvchad.mappings)
├── configs/                      # Detailed plugin configurations
│   ├── lazy.lua                 # Plugin manager settings + disabled built-in plugins
│   ├── lspconfig.lua            # LSP server configurations (uses vim.lsp.config API)
│   ├── conform.lua              # Formatter configuration with auto-format
│   └── copilot.lua              # GitHub Copilot settings
└── plugins/                      # Plugin specifications
    ├── init.lua                 # Core plugins (conform, lspconfig, treesitter)
    └── others.lua               # Additional plugins (git, editing, UI)
```

### Plugin Management Strategy

**Tool:** lazy.nvim with aggressive lazy loading (`defaults = { lazy = true }`)

**Loading Patterns:**
- Event-based: Most plugins load on `BufRead`, `InsertEnter`, or `BufWritePre`
- Command-based: Some load only when commands are invoked
- Key-based: Some plugins load on specific keybindings

**Performance Optimizations:**
The configuration disables 16+ built-in Vim plugins in `configs/lazy.lua`:
- netrw, matchit, tar, zip, gzip, tutor, syntax, ftplugin, etc.

This significantly improves startup time.

### LSP Configuration Architecture

**Location:** `lua/configs/lspconfig.lua`

**Modern API Pattern (vim.lsp.config):**
```lua
-- Global defaults applied to all servers
vim.lsp.config("*", { on_init, on_attach, capabilities })

-- Server-specific configuration
vim.lsp.config(name, opts)

-- Activate server
vim.lsp.enable(name)
```

**Ruby Linter Auto-Detection:**
The configuration automatically detects which Ruby linter to use based on project files:
- If `.standard.yml` exists → enables `standardrb` via `bundle exec`
- If `.rubocop.yml` exists → enables `rubocop` via `bundle exec`

This replaces hardcoded project name checks and works for any Ruby project.

**Language Servers:**
- **Go:** gopls with gofumpt, goimports, unused params analysis
- **Ruby:** ruby_lsp + auto-detected standardrb/rubocop
- **JavaScript/TypeScript:** ts_ls (JavaScript validation enabled, checkJs disabled)
- **React/TypeScript:** typescript-tools.nvim with auto-imports and organize imports
- **Python:** pyright
- **Web:** cssls, html, eslint
- **Emmet:** emmet_language_server for HTML/CSS/React
- **TailwindCSS:** tailwindcss with auto-detection

### Formatting System

**Tool:** conform.nvim (`lua/configs/conform.lua`)

**Configuration:**
- **Format on save:** Enabled with 2500ms timeout
- **LSP fallback:** If no formatter configured for filetype, uses LSP formatting
- **Go formatters:** Chained sequence: gofumpt → goimports → goimports-reviser → golines
- **Lua formatter:** stylua
- **JavaScript/TypeScript/React:** Biome (fast, modern formatter + linter)
- **JSON:** Biome
- **CSS/SCSS/HTML/Markdown/YAML:** Prettier (Biome doesn't support these yet)

**Why Biome?**
- Much faster than Prettier for JS/TS
- Built-in linting capabilities
- Better error messages
- Compatible with existing ESLint projects

Loads lazily on `BufWritePre` event.

### Project-Specific Configuration System

**Mechanism:** Automatic `.nvim.lua` loading from project root

**Loaded at:** End of initialization sequence (after all default configs)

**Use cases:**
- Project-specific LSP overrides
- Custom keybindings for specific codebases
- Autocommands for particular workflows
- Per-project settings that shouldn't be global

**Example `.nvim.lua`:**
```lua
-- Override format timeout for large project
require("conform").setup({ format_on_save = { timeout_ms = 5000 } })

-- Add project-specific keybinding
vim.keymap.set("n", "<leader>t", ":!make test<CR>")
```

### Tmux Integration

**Plugin:** vim-tmux-navigator (loaded immediately, not lazy)

**Custom Mappings:**
- `<C-h>` → TmuxNavigateLeft
- `<C-j>` → TmuxNavigateDown
- `<C-k>` → TmuxNavigateUp
- `<C-l>` → TmuxNavigateRight

**Important:** These mappings override NvChad's default window navigation.

### GitHub Copilot Setup

**Plugin:** zbirenbaum/copilot.lua

**Node.js Requirement:**
- Copilot requires Node.js 22+
- Configured to use: `/Users/amree/.asdf/installs/nodejs/24.11.0/bin/node`
- This bypasses asdf's project-based version resolution to ensure Copilot always has Node.js 24

**Custom Keybindings:**
- `<M-l>` - Accept suggestion
- `<M-]>` - Next suggestion
- `<M-[>` - Previous suggestion
- `<C-]>` - Dismiss suggestion

**Disabled filetypes:** yaml, markdown, help, gitcommit, gitrebase

### Key Customizations

- Leader key: `<Space>` (NvChad default)
- Insert mode escape: `jk` → `<ESC>`
- Colorcolumn: 80 and 100 characters
- Swap files: Disabled (`o.swapfile = false`)
- Trailing whitespace: Auto-removed on save (mini.trailspace)
- Theme: "ashes" (dark) with toggle to "github_light"

### React/TypeScript/Vite Development

**Complete setup for modern web development:**

**Syntax Highlighting:**
- Treesitter parsers for: JavaScript, TypeScript, TSX, JSX, JSON, JSONC, CSS, SCSS, Markdown

**Auto-Completion:**
- TypeScript LSP (`ts_ls`) for basic IntelliSense
- typescript-tools.nvim for enhanced features:
  - Auto-imports on completion
  - Organize imports on save
  - JSX close tag completion
  - Complete function calls with signatures
- Copilot for AI-powered suggestions
- blink.cmp for fast completion engine

**Formatting & Linting:**
- Biome for JS/TS/React/JSON (fast, modern)
- Prettier for CSS/HTML/Markdown
- ESLint LSP for existing projects with custom rules
- Format on save enabled (2.5s timeout)

**Emmet Support:**
- emmet_language_server works in HTML, CSS, and React (JSX/TSX)
- Expand abbreviations like `div.container>ul>li*3` with tab completion

**TailwindCSS:**
- Auto-detection via tailwind.config.js/ts
- IntelliSense for class names
- Color previews
- Hover documentation

**Package Management:**
- package-info.nvim shows versions inline in package.json
- Visual indicators for outdated packages
- Quick actions to update dependencies

**Key Features:**
1. **Auto-imports:** Type a component name, get automatic import statement
2. **Organize imports:** Remove unused, sort alphabetically on save
3. **JSX close tags:** Auto-complete closing tags in React
4. **Emmet in JSX:** Use Emmet abbreviations in React components
5. **Format on save:** Consistent code style with Biome
6. **ESLint integration:** Existing ESLint configs still work

## Common Commands

### Plugin Management
```vim
:Lazy update          " Update all plugins
:Lazy sync            " Clean, install, update all
:Lazy clean           " Remove unused plugins
:Lazy check           " Check for updates without updating
:Lazy profile         " Profile startup time
```

### LSP Management
```vim
:Mason                " Open Mason UI for LSP/formatter installation
:MasonUpdate          " Update Mason itself
:LspInfo              " Show active LSP clients and their status
```

### Git Operations
```vim
:Git <command>        " vim-fugitive commands (commit, push, pull, etc.)
:DiffviewOpen         " Open advanced diff viewer
:DiffviewClose        " Close diff viewer
```

### Theme
```vim
:Nvui theme          " Toggle between ashes (dark) and github_light
```

## Adding New Plugins

1. Add plugin specification to `lua/plugins/init.lua` (core functionality) or `lua/plugins/others.lua` (enhancements)
2. Create detailed configuration in `lua/configs/<plugin-name>.lua` if needed
3. Reference the config in the plugin spec: `config = function() require("configs.<plugin-name>") end`
4. Use lazy loading when possible: specify `event`, `cmd`, or `keys`

## Important Implementation Details

### Why vim.lsp.config Instead of lspconfig.setup()

This configuration uses the modern `vim.lsp.config()` API (Neovim 0.10+) instead of the deprecated `require('lspconfig')[name].setup()` pattern. This:
- Eliminates deprecation warnings from nvim-lspconfig
- Prepares for nvim-lspconfig v3.0.0
- Uses Neovim's native LSP API
- Sets global defaults once with `vim.lsp.config("*", {...})`

### Why Specific Node.js Path for Copilot

The configuration points Copilot to a specific Node.js installation rather than using asdf shims. This ensures Copilot always uses Node.js 24 even when working in projects with older Node.js versions in `.tool-versions`.