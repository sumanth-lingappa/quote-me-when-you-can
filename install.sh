#!/usr/bin/env bash

set -e

QUOTE_DIR="$HOME/.quote-me"
if [[ "${SHELL:-}" == */bash ]]; then
  SHELL_RC="$HOME/.bashrc"
else
  SHELL_RC="$HOME/.zshrc"
fi

case "${1:-}" in
  --uninstall)
    [[ -f "$SHELL_RC" ]] && sed -i.bak '/# quote-me start/,/# quote-me end/d' "$SHELL_RC" && rm "$SHELL_RC.bak"
    exit 0
    ;;
  --update)
    git -C "$QUOTE_DIR" pull --ff-only
    ;;
  '')
    if [[ -d "$QUOTE_DIR" ]]; then
      echo "Already installed. Run: bash install.sh --update"
      exit 0
    fi
    git clone https://github.com/sumanth-lingappa/quote-me-when-you-can.git "$QUOTE_DIR"
    ;;
  *)
    echo "Usage: bash install.sh [--update|--uninstall]"
    exit 1
    ;;
esac

command -v fortune >/dev/null || { echo "Install Fortune first: brew install fortune"; exit 1; }
bash "$QUOTE_DIR/scripts/update_fortune.sh"

[[ -f "$SHELL_RC" ]] && sed -i.bak '/# quote-me start/,/# quote-me end/d' "$SHELL_RC" && rm "$SHELL_RC.bak"

cat >> "$SHELL_RC" <<'EOF'

# quote-me start
alias fortune='command fortune "$HOME/fortunes"'
if [[ $- == *i* ]]; then
  fortune
fi
# quote-me end
EOF
