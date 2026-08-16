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
    if [[ -d "$QUOTE_DIR/.git" ]]; then
      git -C "$QUOTE_DIR" pull --ff-only
      exec bash "$QUOTE_DIR/install.sh" --update
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
quote-me-update() {
  git -C "$HOME/.quote-me" pull --ff-only && bash "$HOME/.quote-me/scripts/update_fortune.sh"
}

fortune() {
  case "${1:-}" in
    --update) quote-me-update ;;
    --auto-update) printf 'true\n' > "$HOME/.quote-me-auto-update"; quote-me-update ;;
    --no-auto-update) rm -f "$HOME/.quote-me-auto-update" ;;
    *) command fortune "$@" "$HOME/fortunes" ;;
  esac
}

quote-me-check-update() {
  git -C "$HOME/.quote-me" fetch --quiet origin master 2>/dev/null || return
  [[ "$(git -C "$HOME/.quote-me" rev-parse HEAD)" == "$(git -C "$HOME/.quote-me" rev-parse origin/master)" ]] && return
  if [[ -f "$HOME/.quote-me-auto-update" ]]; then
    fortune --update
  else
    printf '\nNew quotes are available. Run fortune --update, or fortune --auto-update to update automatically.\n'
  fi
}

if [[ $- == *i* ]]; then
  fortune
  quote-me-check-update
fi
# quote-me end
EOF
