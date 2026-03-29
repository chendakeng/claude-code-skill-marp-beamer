# claude-code-skill-marp-beamer

A Claude Code skill for creating academic presentations in Marp with a beamer-style theme — dark-blue header bar, three-section footer, styled tables, and definition blocks. Written from scratch to fix recurring CSS bugs in existing beamer themes.

**Languages:** [English](#overview) · [中文](GUIDE_ZH.md)

---

## Overview

This skill gives Claude a complete reference for:

- Writing Marp slide decks (Marpit directives, image syntax, math, VS Code setup)
- Building a beamer-style CSS theme from scratch
- Diagnosing and fixing the two most common beamer CSS bugs
- Generating slide templates for academic talks

## Skill structure

```
skill_marp_beamer/
├── SKILL.md                      # Entry point: routing table + critical rules
├── references/
│   ├── marpit-syntax.md          # Marp markdown syntax, directives, image syntax
│   ├── beamer-css.md             # CSS architecture, bug fixes, colour customisation
│   └── slide-templates.md        # Full deck template + individual slide patterns
└── assets/
    └── beamer.css                # Ready-to-copy CSS file
```

## Installation

### Claude Code (humans)

```
/plugin marketplace add chendakeng/claude-code-skill-marp-beamer
/plugin install marp-beamer@claude-code-skill-marp-beamer
```

### Claude Code (AI agents)

Ask your agent:

> Install the marp-beamer skill from https://github.com/chendakeng/claude-code-skill-marp-beamer

### Manual

```bash
git clone https://github.com/chendakeng/claude-code-skill-marp-beamer ~/.claude/skills/marp-beamer
```

## Quick start

1. Copy `assets/beamer.css` → `.vscode/beamer.css` in your project
2. Create `.vscode/settings.json`:
   ```json
   { "markdown.marp.themes": [".vscode/beamer.css"] }
   ```
3. Reload VS Code (`Cmd+Shift+P → Reload Window`)
4. Add frontmatter to your `.md` file:
   ```yaml
   ---
   marp: true
   theme: beamer
   paginate: true
   footer: '**Author** **Title** **Venue · Date**'
   style: |
     :root {
       /* ── Colour palette (change --primary to recolour everything) ── */
       --primary:        #3333b2;
       --primary-dark:   #25259e;
       --primary-darker: #1a1a80;
       --primary-light:  #9999dd;
       --bg-stripe:      #ededf8;
       --bg-stripe2:     #f5f5fc;

       /* ── Layout & typography ── */
       --font-size:  22px;
       --pad-x:      2.5rem;
       --header-h:   2.4rem;
       --footer-h:   1.4rem;
       --radius:     0.45rem;

       /* ── Element widths ── */
       --defblock-width:   88%;
       --table-max-width:  92%;
       --blockquote-width: 90%;
       --img-max-width:    80%;
       --title-h1-width:   85%;
     }
   ---
   ```
   Every token is overridable per-deck — delete what you don't need to change, or keep them all as a self-documenting control panel.

## Theme tokens

All design values are CSS custom properties. Override any of them per-deck in the frontmatter `style:` block — no CSS file editing needed.

### Colour palette

| Token | Default | Controls |
|-------|---------|---------|
| `--primary` | `#3333b2` | Header bar, table headers, definition block title, title h1 box, footer right |
| `--primary-dark` | `#25259e` | Footer centre segment, definition block body, table th border |
| `--primary-darker` | `#1a1a80` | Footer left segment (darkest) |
| `--primary-light` | `#9999dd` | **h2 underline · standard blockquote left border** — the accent colour |
| `--bg-stripe` | `#ededf8` | Inline code background |
| `--bg-stripe2` | `#f5f5fc` | Table even-row tint, standard blockquote background |

Always set all 6 colour tokens together — partial overrides leave mismatched shades. See `references/beamer-css.md` for preset palettes (teal, burgundy, slate grey).

### Layout & typography

| Token | Default | Controls |
|-------|---------|---------|
| `--font-size` | `22px` | Base text size for all slide content |
| `--pad-x` | `2.5rem` | Left/right content padding |
| `--header-h` | `2.4rem` | Height of the top header bar |
| `--footer-h` | `1.4rem` | Height of the bottom footer bar |
| `--radius` | `0.45rem` | Border radius applied consistently everywhere |

### Element widths

| Token | Default | Controls |
|-------|---------|---------|
| `--defblock-width` | `88%` | Definition blocks (`> #### Title` syntax) |
| `--table-max-width` | `92%` | Tables |
| `--blockquote-width` | `90%` | Standard blockquotes (left-border style) |
| `--img-max-width` | `80%` | Inline images |
| `--title-h1-width` | `85%` | Title-slide h1 box |

**Example — widen a definition block on one slide:**
```yaml
style: |
  :root {
    --defblock-width: 100%;
  }
```

## Fonts

| Font | Purpose | Loading |
|------|---------|---------|
| Roboto | Latin / English | Google Fonts CDN |
| Noto Sans TC | Traditional Chinese | Google Fonts CDN |
| Noto Sans SC | Simplified Chinese | Google Fonts CDN |
| PingFang TC / SC | CJK fallback | macOS system font |

All three Google fonts are loaded via `@import` in `beamer.css` — nothing to configure per-deck. Noto CJK fonts are served as smart unicode-range subsets by Google's CDN (only the glyphs actually used are downloaded), so bundling them locally is not practical.

**Offline behaviour:** Roboto and Noto Sans require internet. If unavailable, Latin falls back to system sans-serif and Chinese falls back to PingFang TC/SC (built into macOS — high quality and always available).

## The two CSS bugs this skill fixes

### Shadow column on tables

**Symptom:** A phantom column (same background as the header, no text) appears to the right of the last real column.

**Cause:** `background-color` on the `<table>` element bleeds into empty space when the table is wider than its columns.

**Fix:**
```css
table {
  border-collapse: collapse;
  background: none;        /* never put background on the table element */
  width: fit-content;
}
```

### Gap line in definition blockquotes

**Symptom:** A thin visible seam between the title bar and body of a `> #### Heading` block.

**Cause:** `border-radius` applied to all four corners of both `h4` and `p` children reveals the parent background where they meet.

**Fix:**
```css
blockquote:has(> h4) { border-radius: 0.45rem; overflow: hidden; }
blockquote:has(> h4) h4 { border-radius: 0; }
blockquote:has(> h4) p  { border-radius: 0; }
```

## Eval results

Tested against 3 representative tasks (create full deck, fix shadow column, fix blockquote gap):

| | With skill | Without skill |
|---|---|---|
| Pass rate | **100%** | 80% ± 28% |

The skill's main contribution is the precise three-part table fix — without it, Claude correctly identifies the general problem but misses `background: none` and `width: fit-content`.

## Comparison with neobeam

`beamer.css` is inspired by [neobeam](https://github.com/mikael-ros/neobeam) but is a full rewrite. A 108-rule audit found the following deliberate differences:

### Intentional simplifications

| Area | neobeam | beamer.css |
|---|---|---|
| Colour system | ~30 computed HSL tokens | ~14 static hex tokens — easier to customise |
| Footer | Overlapping pill/tab segments with negative margins | Flat three-section flex layout |
| Slide alignment | Vertically centred content | Top-aligned — better for dense academic slides |
| Definition block colours | Cycles 3 highlight colours | Always primary blue |
| Semantic HTML | Styles `<mark>`, `<var>`, `<samp>`, `<q>` | Not included |
| Image captions, logo, animations | Present | Not included |

### Bug fixes relative to neobeam

| Bug | neobeam | beamer.css |
|---|---|---|
| **Table corner notch** | Uses `border-spacing: 0`; cell-level `border-radius` works correctly | Fixed via `border-radius` + `overflow: hidden` on the `table` element |
| **Definition block gap line** | `border-radius` on all child corners + flex sizing; can leak a seam if padding misaligns | `overflow: hidden` on parent + `border-radius: 0` on children — no seam possible |
| **Inline code font** | `font-family: monospace` set explicitly | Same fix applied |

### Enhancements over neobeam

- `h2` underline border for visual section separation
- Explicit column text-align and `vertical-align: middle` on table cells
- Image max-width 80% (vs neobeam's 50%) — more practical for slide content

## Reference

- [Marp](https://marp.app/) — Markdown Presentation Ecosystem
- [Marpit documentation](https://marpit.marp.app/) — directive and image syntax
- [neobeam](https://github.com/mikael-ros/neobeam) — original inspiration for the colour scheme and layout
