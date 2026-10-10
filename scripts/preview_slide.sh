#!/usr/bin/env bash
# Screenshot one slide of a Marp deck as rendered by headless Chrome, in about 2 s.
# For the usual edit-and-check loop, `marp --no-stdin deck.md --images png` is faster
# (4 s for 50 slides); the old "over 2 minutes" timing was marp waiting on stdin.
#
# Usage: preview_slide.sh deck.md SLIDE_INDEX THEME_CSS OUT_PNG
#   SLIDE_INDEX counts from the title slide, so a footer page number N is index N+1
#   when the title slide has `_paginate: skip`.
# Set CHROME_BIN to use a Chrome other than the macOS default install.
# The HTML is written next to the deck (images are linked relative to it) and removed after.
set -euo pipefail
chrome=${CHROME_BIN:-"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"}
deck=$1; idx=$2; theme=$3; out=$4
dir=$(cd "$(dirname "$deck")" && pwd)
html="$dir/_preview_$$.html"
trap 'rm -f "$html"' EXIT
marp --no-stdin "$deck" --allow-local-files --theme-set "$theme" --html -o "$html" >/dev/null 2>&1
"$chrome" --headless=new --disable-gpu \
  --hide-scrollbars --window-size=1280,720 --virtual-time-budget=3000 \
  --screenshot="$out" "file://$html#$idx" >/dev/null 2>&1
echo "$out"
