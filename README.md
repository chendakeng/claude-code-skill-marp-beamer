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
├── GUIDE_ZH.md                   # Chinese user guide
├── scripts/
│   └── preview_slide.sh          # One slide as a headless-Chrome screenshot
├── references/
│   ├── marpit-syntax.md          # Marp markdown syntax, directives, image syntax
│   ├── beamer-css.md             # CSS architecture, bug fixes, colour customisation
│   └── slide-templates.md        # Full deck template + individual slide patterns
└── assets/
    └── beamer.css                # Ready-to-copy CSS file
```

## Installation

### Claude Code (AI agents)

Ask your agent:

> Install the marp-beamer skill from https://github.com/chendakeng/claude-code-skill-marp-beamer

### Manual

```bash
git clone https://github.com/chendakeng/claude-code-skill-marp-beamer ~/.claude/skills/claude-code-skill-marp-beamer
```

## Quick start

1. Copy `assets/beamer.css` → `.vscode/beamer.css` in your project
2. Create `.vscode/settings.json`:
   ```json
   {
     "markdown.marp.themes": [".vscode/beamer.css"],
     "markdown.marp.html": true
   }
   ```
3. Reload VS Code (`Cmd+Shift+P → Reload Window`)
4. Add frontmatter to your `.md` file:
   ```yaml
   ---
   marp: true
   theme: beamer
   lang: en-US
   math: mathjax
   paginate: true
   footer: '**Author** **Title** **Venue · Date**'
   style: |
     :root {
       /* ── Colour palette — the only block most decks need ── */
       --primary:        #3333b2;
       --primary-dark:   #25259e;
       --primary-darker: #1a1a80;
       --primary-light:  #9999dd;   /* h2 underline, blockquote border */
       --bg-stripe2:     #f5f5fc;   /* table even rows */
       --code-bg:        #e2e2f4;   /* inline code chip fill */
       --code-fg:        #22226b;
       --code-border:    #c2c2e6;
       --table-border:   #d0d0e8;   /* table cell borders */
     }
   ---
   ```
   Use `lang: zh-CN` for a Chinese deck (the body font becomes 宋体). Keep `math: mathjax`: `katex` loads its fonts from a CDN. Never put a `# comment` on a directive line; Marp reads it as part of the value and, for `theme:`, silently drops the theme.

   Set the 9 colour tokens together; partial overrides leave mismatched shades. Layout tokens (`--font-size`, `--pad-x`, `--img-max-width`, …) are overridable the same way when a deck needs them — see the token tables below.

   Do **not** put `section.*` utility classes here. They ship in the theme.

## Theme tokens

All design values are CSS custom properties. Override any of them per-deck in the frontmatter `style:` block — no CSS file editing needed.

### Colour palette

| Token | Default | Controls |
|-------|---------|---------|
| `--primary` | `#3333b2` | Header bar, table headers, definition block title, title h1 box, footer right |
| `--primary-dark` | `#25259e` | Footer centre segment, definition block body, table th border |
| `--primary-darker` | `#1a1a80` | Footer left segment (darkest) |
| `--primary-light` | `#9999dd` | **h2 underline · standard blockquote left border** — light blue accent |
| `--bg-stripe` | `#ededf8` | Legacy alias — no rule reads it. Superseded by `--code-bg` |
| `--bg-stripe2` | `#f5f5fc` | Table even-row tint, standard blockquote background |
| `--code-bg` | `#e2e2f4` | Inline code chip fill |
| `--code-fg` | `#22226b` | Inline code chip text |
| `--code-border` | `#c2c2e6` | Inline code chip border |
| `--table-border` | `#d0d0e8` | Table cell borders — recolour with the palette |
| `--muted` | `#555555` | Title-slide h3 and title blockquote |
| `--caption-fg` | `#666666` | `.caption` text |

Always set the 9 palette tokens together — partial overrides leave mismatched shades. `--muted` and `--caption-fg` are hue-neutral greys and rarely need changing.

**`--code-bg` must stay clearly darker than `--bg-stripe2`.** A code chip inside a table sits on the even-row fill, so if the two are close the chip disappears and the token reads as body text. Check chips on an *even* table row, not on the slide background where they always look fine.

See `references/beamer-css.md` for preset palettes (SCNU blue, CUHK purple & gold, teal, burgundy, slate grey) and the recipe for deriving a palette from one institutional colour.

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
| `--img-max-width` | `100%` | Inline images |
| `--title-h1-width` | `85%` | Title-slide h1 box |

**Deck-wide example — widen all definition blocks:**
```yaml
style: |
  :root {
    --defblock-width: 100%;
  }
```

## Per-slide overrides

CSS variables set in `:root` apply deck-wide. To change one slide only, apply a
utility class with `<!-- _class: name -->`. The theme ships these:

| Class | Effect |
|:------|:-------|
| `small-text` | 19px body text |
| `large-text` | 26px body text |
| `tight` | Tighter line height (1.3), lists stay at 1.5 |
| `vcenter` | Vertically centres the slide's content |
| `center-table` | Centres the table horizontally |
| `small-table` | Table text at 0.72em |
| `wide-table` | Table spans the full content width |
| `wide-defblock` | Definition block spans the full content width |
| `wide-quote` | Standard blockquote spans the full content width |

```markdown
<!-- _class: small-text tight -->
```

Because they live in the theme, decks do not declare them. If a deck needs a
different value, override that one rule in its `style:` block:

```yaml
style: |
  section.small-text { font-size: 18px; }   /* theme default is 19px */
```

A brand-new `section.*` rule in a deck's frontmatter is a signal it belongs in
`assets/beamer.css` instead — otherwise two decks needing it will drift apart.

```markdown
<!-- _class: wide-defblock -->

> #### Key Finding
> This definition block is full-width on this slide only.

---

<!-- _class: wide-table small-text -->

## Dense Table Slide  ← table is full-width AND text is 18px, this slide only
```

**Rules:**
- `section.classname` scoping is required — without it the rule bleeds to all slides
- Multiple classes are space-separated: `<!-- _class: wide-table small-text -->`
- `_class` replaces the slide's class entirely — combine with built-ins when needed:
  `<!-- _class: title wide-defblock -->`
- **`_style` is NOT a valid Marp directive** — it is silently ignored
- **`:root` variable overrides inside `_class` rules do NOT work** — Marp does not
  re-evaluate CSS custom properties at section scope; target elements directly instead

## Utility classes

The theme ships two CSS utility classes for centering content. Unlike `![center]` (images only), these work on any HTML element.

| Class | Usage | Effect |
|:------|:------|:-------|
| `.center` | `<div class="center">text</div>` | Centers text and inline content; also auto-centers any `<table>` inside |
| `.caption` | `<div class="caption">Figure 1.</div>` | Centered, `0.78em`, grey — for figure labels |

**Centering a markdown table** requires a slide-level class, since markdown tables can't be wrapped in a `<div>`. `center-table` ships in the theme, so just apply it:

```markdown
<!-- _class: center-table -->

## Results

| A | B |
|:--|:--|
| 1 | 2 |
```

All HTML-based utilities require `"markdown.marp.html": true` in `.vscode/settings.json`. After changing this setting, reload VS Code (`Cmd+Shift+P → Reload Window`).

> **Note on theme CSS vs frontmatter style:** Newly added utility classes in `beamer.css` require a VS Code window reload to take effect in the preview. Reload before concluding a class does not work; do not copy it into the frontmatter.

---

## Fonts

All fonts are local system fonts; `beamer.css` makes **no network request**. The deck's `lang:`
directive picks the stack, so always set it.

| `lang:` | Body font | Fallback chain |
|---------|-----------|----------------|
| `en-US` (or unset) | Times New Roman, for English text and its quotes | Times → Georgia → Liberation Serif → (Chinese characters: Songti SC → SimSun → PingFang SC → Microsoft YaHei) → serif |
| `zh-CN` | 宋体 for everything, including “” ‘’ …… | Songti SC (Mac) → STSong → SimSun / NSimSun (Windows) → Noto / Source Han Serif → PingFang SC → Microsoft YaHei → Times New Roman → serif |
| `zh-TW`, `zh-HK` | 宋體 / 明體 | Songti TC → PMingLiU / MingLiU → Noto / Source Han Serif TC → PingFang TC → Microsoft JhengHei → serif |
| code | monospace | Menlo → Consolas → Courier New → monospace |

To use another face in one deck, override `--font-en` or `--font-zh` in its `:root` style block,
with a font installed on the presenting machine.

**Do not add a Google Fonts (or any CDN) `@import`.** Where `fonts.googleapis.com` is blocked
(mainland China, many campus networks) the request hangs rather than fails, and an exported HTML
deck stays blank until it times out. PDF builds hide the problem. The same applies to math:
use `math: mathjax`; `math: katex` fetches its fonts from `cdn.jsdelivr.net` (24.5 s to load with
remote hosts blocked, against 0.5 s for MathJax).

## CSS bugs this skill fixes

Four in total; the other two (inline code chips vanishing on striped rows, and Marp's paragraph margin winning over the reset) are in `SKILL.md` § Critical CSS design rules.

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
| **Inline code font** | `font-family: monospace` set explicitly | Explicit stack: Menlo, Consolas, Courier New, monospace |

### Enhancements over neobeam

- `h2` underline border for visual section separation
- Explicit column text-align and `vertical-align: middle` on table cells
- Image max-width 100% (vs neobeam's 50%), more practical for slide content

## Reference

- [Marp](https://marp.app/) — Markdown Presentation Ecosystem
- [Marpit documentation](https://marpit.marp.app/) — directive and image syntax
- [neobeam](https://github.com/mikael-ros/neobeam) — original inspiration for the colour scheme and layout
