#!/bin/sh
# Discard local plugin patches so `:Lazy sync` can update. Re-apply with apply.sh.
set -e
dir=$(cd "$(dirname "$0")" && pwd)
lazy=${LAZY_DIR:-$HOME/.local/share/nvchad/lazy}

for p in "$dir"/*.patch; do
  plugin=$(basename "$p" .patch)
  git -C "$lazy/$plugin" checkout -- . && echo "reset: $plugin"
done
