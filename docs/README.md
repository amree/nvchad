# React/TypeScript Project Configuration Examples

This directory contains example configuration files for React/TypeScript/Vite projects that work well with this NvChad setup.

## biome.json.example

Minimal Biome configuration for formatting and linting JavaScript/TypeScript/React code.

**Key settings:**

- `noUnusedVariables: "off"` - Disables Biome's unused variable warnings to avoid duplicate warnings with TypeScript LSP
- `quoteStyle: "double"` - Uses double quotes for consistency
- `semicolons: "always"` - Always use semicolons

**Usage:**

Copy to your project root:
```bash
cp docs/biome.json.example /path/to/project/biome.json
```

Biome will automatically:
- Remove unused imports on save (via conform.nvim with `--unsafe` flag)
- Format code on save
- Organize imports

## eslint.config.js.example

Minimal ESLint configuration with only React-specific rules to avoid duplication with TypeScript LSP and Biome.

**Key settings:**

- Only includes `reactHooks.configs.flat.recommended` for React hooks rules
- Only includes `reactRefresh.configs.vite` for Vite HMR compatibility
- Does NOT include TypeScript linting rules (handled by TypeScript LSP)
- Does NOT include general code quality rules (handled by Biome)

**Why minimal?**

This configuration avoids duplicate warnings by letting each tool focus on what it does best:
- **TypeScript LSP** - Type checking and unused variables
- **Biome** - Code formatting and general linting
- **ESLint** - React-specific rules (hooks dependencies, refresh compatibility)

**Usage:**

Copy to your project root:
```bash
cp docs/eslint.config.js.example /path/to/project/eslint.config.js
```

**Required dependencies:**

```bash
npm install -D eslint globals eslint-plugin-react-hooks eslint-plugin-react-refresh typescript-eslint
```

## How it works with NvChad

This NvChad configuration includes:
- **typescript-tools.nvim** - Enhanced TypeScript features (auto-imports, JSX close tags)
- **conform.nvim** - Runs `biome-check --write --unsafe` on save
- **nvim-lspconfig** - ESLint LSP for inline diagnostics

All three tools work together without duplicating warnings or errors.
