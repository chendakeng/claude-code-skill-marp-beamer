#!/usr/bin/env bash
# Screenshot one slide of a Marp deck in about 15 s (a full PDF of 50 slides takes ~50 s,
# and --images png takes over 2 minutes, which exceeds a 120 s tool timeout).
#
# Usage: preview_slide.sh deck.md SLIDE_INDEX THEME_CSS OUT_PNG
#   SLIDE_INDEX counts from the title slide, so a footer page number N is index N+1
#   when the title slide has `_paginate: skip`.
# The HTML is written next to the deck (images are linked relative to it) and removed after.
set -euo pipefail
deck=$1; idx=$2; theme=$3; out=$4
dir=$(cd "$(dirname "$deck")" && pwd)
html="$dir/_preview_$$.html"
trap 'rm -f "$html"' EXIT
marp "$deck" --allow-local-files --theme-set "$theme" --html -o "$html" >/dev/null 2>&1
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --disable-gpu \
  --hide-scrollbars --window-size=1280,720 --virtual-time-budget=3000 \
  --screenshot="$out" "file://$html#$idx" >/dev/null 2>&1
echo "$out"
