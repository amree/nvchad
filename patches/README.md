# Plugin Patch Playbook

Two upstream plugins are patched locally for Neovim 0.12.2 compatibility. Lazy
installs plugins as git clones, so `:Lazy sync` refuses to update any plugin
with a dirty working tree. That is why updates fail with:

```
You have local changes in `~/.local/share/nvchad/lazy/<plugin>`
Please remove them to update.
```

The patches live here as `.patch` files so they can be discarded before an
update and re-applied after.

## Update routine

1. Run `:Lazy sync` in Neovim.
2. If it fails with "You have local changes", quit Neovim and run
   `~/.config/nvchad/patches/reset.sh`, then repeat step 1.
3. Quit Neovim, run `~/.config/nvchad/patches/apply.sh`.
4. Reopen Neovim. Sanity check: open a `.rb` file, type `def foo` and press
   Enter — `end` should be inserted with no error. Trigger an LSP load and
   confirm no `LspProgress` errors in `:messages`.

If `apply.sh` reports "patch does not apply", upstream changed the surrounding
lines. Re-derive the fix by hand from the explanations below, then regenerate
the patch with `git -C <plugin dir> diff > patches/<plugin>.patch`.

## Checking whether a patch is still needed

Both fixes have been sent upstream (see `../handoff/nvchad-ui-pr-handoff.md`).
Once merged, delete the patch file instead of re-applying it. To check:

```sh
cd ~/.local/share/nvchad/lazy/ui
git fetch origin
git show origin/HEAD:lua/nvchad/stl/utils.lua | grep 'type(data.percentage)'

cd ~/.local/share/nvchad/lazy/nvim-treesitter-endwise
git fetch origin
git show origin/HEAD:lua/nvim-treesitter/endwise.lua | grep 'suffix_match'
```

A match means the fix landed upstream and the patch can go.

Last verified still needed: 2026-08-08.

## The patches

### `ui.patch` — NvChad/ui, `lua/nvchad/stl/utils.lua`

Neovim 0.12.2 represents JSON `null` in LSP progress notifications as `vim.NIL`
(a userdata value) rather than Lua `nil`. Userdata is truthy, so the existing
`if data.percentage then` guards pass, and the value then blows up whatever
consumes it:

- `data.percentage` → `attempt to perform arithmetic on a userdata value`
- `data.message` → `bad argument #1 to 'match' (string expected, got userdata)`
- `data.title` → same risk on string concat

The patch replaces the truthy guards with `type()` checks.

### `nvim-treesitter-endwise.patch` — RRethy/nvim-treesitter-endwise, `lua/nvim-treesitter/endwise.lua`

The plugin registers its `endwise!` directive with `all = false`, a compat shim
for Neovim 0.10. Neovim 0.12.2 removed the auto-unwrap behind that flag, so
directive callbacks now always receive a *list* of nodes per capture. The
callback stored `match[predicate[3]]` raw, and the later `:range()` call fails:

```
attempt to call method 'range' (a nil value)
```

The patch unwraps the last node from the list with an explicit `if/else`.

**Do not "simplify" it to a ternary.** `type(t) == "table" and t[#t] or t` looks
equivalent but has the Lua falsy trap: for an empty list `{}`, `t[#t]` is `nil`,
so the expression falls through to `t` — the empty table. Empty tables are
truthy, the downstream guard passes, and `:range()` fails again. The `if/else`
correctly yields `nil`.
