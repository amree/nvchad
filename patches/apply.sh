#!/bin/sh
# Re-apply local plugin patches after `:Lazy sync` wipes them.
# These fix Neovim 0.12.2 vim.NIL / iter_matches breakage; see ../handoff/.
set -e
dir=$(cd "$(dirname "$0")" && pwd)
lazy=${LAZY_DIR:-$HOME/.local/share/nvchad/lazy}

for p in "$dir"/*.patch; do
  plugin=$(basename "$p" .patch)
  git -C "$lazy/$plugin" apply "$p" && echo "applied: $plugin"
done
