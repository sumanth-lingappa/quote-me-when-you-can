FROM ubuntu:24.04

ENV PATH="/usr/games:${PATH}"

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates fortune-mod git zsh && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

RUN HOME=/tmp/quote-home bash install.sh \
 && HOME=/tmp/quote-home bash install.sh \
 && FIRST="$(HOME=/tmp/quote-home zsh -ic 'true')" \
 && SECOND="$(HOME=/tmp/quote-home zsh -ic 'true')" \
 && test -n "$FIRST" \
 && test -n "$SECOND" \
 && HOME=/tmp/quote-home bash install.sh --uninstall \
 && ! grep -q 'quote-me start' /tmp/quote-home/.zshrc
