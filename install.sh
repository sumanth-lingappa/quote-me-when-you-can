#!/usr/bin/env bash

set -e

QUOTE_DIR="$HOME/.quote-me"
SHELL_RC="$HOME/.zshrc"

case "${1:-}" in
  --uninstall)
    [[ -f "$SHELL_RC" ]] && sed -i '' '/# quote-me start/,/# quote-me end/d' "$SHELL_RC"
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
bash "$QUOTE_DIR/update_fortune.sh"

if [[ "${1:-}" != "--update" ]]; then
  cat >> "$SHELL_RC" <<'EOF'

# quote-me start
QUOTE_DATE_FILE="$HOME/.quote-me-last-shown"
if [[ -o interactive && "$(cat "$QUOTE_DATE_FILE" 2>/dev/null)" != "$(date +%F)" ]]; then
  fortune "$HOME/fortunes"
  date +%F > "$QUOTE_DATE_FILE"
fi
# quote-me end
EOF
fi
