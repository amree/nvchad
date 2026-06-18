# Handoff: Neovim 0.12.2 Plugin Compatibility Fixes

Two upstream plugins need PRs for Neovim 0.12.2 API breakage.

---

## PR 1: NvChad/ui — LspProgress vim.NIL userdata errors

### Target
`https://github.com/NvChad/ui` — branch `v3.0`

### Bug
Neovim 0.12.2 changed how JSON `null` is represented in LSP progress notifications. Fields that are absent/null are now `vim.NIL` (a Lua userdata value) instead of Lua `nil`. Userdata is truthy, so existing truthy guards pass — but passing userdata to functions expecting a string or number throws errors.

Two fields affected in `lua/nvchad/stl/utils.lua`:

#### `data.percentage` (line 172)
Truthy guard passes for `vim.NIL`, then `math.floor(data.percentage / 10)` throws:
```
attempt to perform arithmetic on field 'percentage' (a userdata value)
```

#### `data.message` (line 178)
Truthy guard passes for `vim.NIL`, then `string.match(data.message, ...)` throws:
```
bad argument #1 to 'match' (string expected, got userdata)
```

#### `data.title` (line 179) — not yet crashing, same risk
`(data.title or "")` returns `vim.NIL` when title is null → string concat would blow up.

### File to fix
`lua/nvchad/stl/utils.lua` — lines 172, 178, 179

**GitHub API to get current file:**
```
GET https://api.github.com/repos/NvChad/ui/contents/lua/nvchad/stl/utils.lua
```

### Fix

#### Line 172 — percentage arithmetic guard
```lua
-- before
if data.percentage then

-- after
if data.percentage and type(data.percentage) == "number" then
```

#### Line 178 — message string.match guard
```lua
-- before
local loaded_count = data.message and string.match(data.message, "^(%d+/%d+)") or ""

-- after
local loaded_count = (type(data.message) == "string" and string.match(data.message, "^(%d+/%d+)")) or ""
```

#### Line 179 — title string concat guard
```lua
-- before
local str = progress .. (data.title or "") .. " " .. (loaded_count or "")

-- after
local str = progress .. (type(data.title) == "string" and data.title or "") .. " " .. (loaded_count or "")
```

### PR details
- **PR title:** `fix(stl): guard LSP progress field types for Neovim 0.12.2 vim.NIL compat`
- **PR body:** Neovim 0.12.2 sends `vim.NIL` (userdata) for null LSP progress fields instead of Lua nil. Three fields affected: `percentage` (arithmetic failure), `message` (string.match failure), `title` (string concat risk). Adding `type()` checks fixes all three.

### References
- **Upstream file:** https://github.com/NvChad/ui/blob/v3.0/lua/nvchad/stl/utils.lua
- **Related past fix:** https://github.com/NvChad/ui/pull/374
- **Related guard clause PR:** https://github.com/NvChad/ui/pull/427
- **Prior LspProgress issue:** https://github.com/NvChad/ui/issues/371
- **Neovim 0.12.2 release:** https://github.com/neovim/neovim/releases/tag/v0.12.2

### Steps for agent
1. Fork `NvChad/ui` (or push branch if write access)
2. Fetch current `lua/nvchad/stl/utils.lua` via API above
3. Apply all three fixes (lines 172, 178, 179)
4. Commit: `fix(stl): guard LSP progress field types for Neovim 0.12.2 vim.NIL compat`
5. Open PR against `v3.0` branch

---

## PR 2: RRethy/nvim-treesitter-endwise — iter_matches node list compat

### Target
`https://github.com/RRethy/nvim-treesitter-endwise` — main branch

### Bug
Two compounding issues:

1. `add_directive` is registered with `all = false` (line 5: compat shim for 0.10). Neovim 0.12.2 removed the auto-unwrap shim — directive callbacks now always receive lists regardless of the `all` flag.

2. The naive ternary fix `type(t) == "table" and t[#t] or t` has a Lua falsy-value trap: when `t` is an empty list `{}`, `t[#t]` is `nil` (falsy), so the expression returns `t` (the empty table). Empty tables are truthy in Lua, so `if metadata.endwise_end_suffix then` passes, then `:range()` fails on the table.

The main loop in `endwise()` already handles lists correctly (lines 149-151), but the `add_directive` callback doesn't:

```
vim.schedule callback: .../endwise.lua:169: attempt to call method 'range' (a nil value)
```

### File to fix
`lua/nvim-treesitter/endwise.lua` — line 200

**GitHub API to get current file:**
```
GET https://api.github.com/repos/RRethy/nvim-treesitter-endwise/contents/lua/nvim-treesitter/endwise.lua
```

### Fix

#### Line 200 — unwrap node list in directive callback (explicit if/else required)
```lua
-- before
metadata.endwise_end_suffix = match[predicate[3]]

-- after
local suffix_match = match[predicate[3]]
if type(suffix_match) == "table" then
    metadata.endwise_end_suffix = suffix_match[#suffix_match]
else
    metadata.endwise_end_suffix = suffix_match
end
```

**Why not the ternary `A and B or C`:** when `suffix_match` is an empty table `{}`, `suffix_match[#suffix_match]` is `nil` (falsy), so `A and B or C` returns `C` (the table). Empty tables are truthy, so the `if metadata.endwise_end_suffix then` guard on line 168 passes and `:range()` fails. The explicit `if/else` correctly sets `metadata.endwise_end_suffix = nil`, making the guard skip.

### PR details
- **PR title:** `fix: unwrap node list from directive match for Neovim 0.12.2 compat`
- **PR body:** Neovim 0.12.2 removed the `all = false` auto-unwrap shim in `add_directive`. Directive callbacks now always receive node lists per capture. The main `endwise()` loop already handles this (lines 149-151), but the `#endwise!` directive callback stored `match[predicate[3]]` raw. Fix uses explicit `if/else` (not ternary) to safely unwrap — the ternary `A and B or C` has a Lua falsy-value trap when the list is empty, returning the table instead of `nil` and causing `:range()` to fail.

### Steps for agent
1. Fork `RRethy/nvim-treesitter-endwise`
2. Fetch current `lua/nvim-treesitter/endwise.lua` via API above
3. Apply fix at line 200 (replace 1 line with 5 lines)
4. Commit: `fix: unwrap node list from directive match for Neovim 0.12.2 compat`
5. Open PR against main branch
