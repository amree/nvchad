# README

## Installation

Create a soft link to this directory from the home directory:

```
ln -s /Users/amree/Workspaces/Personal/nvchad ~/.config/nvchad
```

## Updating plugins

Inside Neovim:

```
:Lazy sync
```

Cleans, installs, and updates everything, then writes `lazy-lock.json`. Use
`:Lazy check` first to see what's stale without changing anything.

Also update LSP servers and formatters when needed:

```
:MasonUpdate
```
