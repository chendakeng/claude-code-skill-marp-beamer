# Beamer CSS Reference

Written from scratch to avoid the bugs present in the neobeam theme. The ready-to-copy
full CSS is in `assets/beamer.css`. This file explains the architecture and the two
critical bug fixes.

---

## CSS file structure

Every Marp theme CSS must start with a comment block declaring `@theme`. The theme
name here must match what you write in the slide frontmatter (`theme: beamer`).

```css
/*!
 * @theme beamer
 * @auto-scaling true
 * @size 16:9 1280px 720px
 */

@import url('https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&family=Noto+Sans+SC:wght@300;400;500;700&family=Noto+Sans+TC:wght@300;400;500;700&display=swap');
@import "default";   /* Marp's base reset — always import this */
```

`@auto-scaling true` lets Marp shrink text that overflows a slide.
`@size` sets the slide canvas dimensions.

---

## Design tokens

All values are CSS custom properties in `:root`. Every token can be overridden
per-deck in the frontmatter `style:` block — no CSS file editing needed.

```css
:root {
  /* ── Colour palette ── */
  --primary:        #3333b2;   /* header bar, table th, definition block title, title h1 box, footer right */
  --primary-dark:   #25259e;   /* footer centre, definition block body, table th border */
  --primary-darker: #1a1a80;   /* footer left segment */
  --primary-light:  #9999dd;   /* light blue accent — h2 underline, standard blockquote left border */
  --bg-stripe:      #ededf8;   /* legacy alias — no rule reads it; see --code-bg */
  --bg-stripe2:     #f5f5fc;   /* table even rows, standard blockquote background */
  --code-bg:        #e2e2f4;   /* inline code chip fill */
  --code-fg:        #22226b;   /* inline code chip text */
  --code-border:    #c2c2e6;   /* inline code chip border */
  --table-border:   #d0d0e8;   /* table cell borders — recolour with the palette */
  --muted:          #555555;   /* title-slide h3 and title blockquote */
  --caption-fg:     #666666;   /* .caption */
  --text:           #111122;   /* body text colour */
  --white:          #ffffff;   /* slide background, header/footer text */

  /* ── Layout & typography ── */
  --header-h:  2.4rem;
  --footer-h:  1.4rem;
  --pad-x:     2.5rem;
  --radius:    0.45rem;
  --font-size: 22px;

  /* ── Element widths ── */
  --defblock-width:   88%;  /* definition block  > #### Title  (was hardcoded 62%) */
  --table-max-width:  92%;  /* tables */
  --blockquote-width: 90%;  /* standard blockquotes */
  --img-max-width:    80%;  /* inline images */
  --title-h1-width:   85%;  /* title-slide h1 box */
}
```

The full deck template (`references/slide-templates.md`) includes all tokens with
inline comments — use it as a self-documenting control panel for each new deck.

---

## Section (slide body)

`section` is the flex container for all slide content. The top/bottom padding
compensates for the absolutely-positioned header and footer bars so content
never overlaps them.

```css
section {
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  background: var(--white);
  font-family: 'Roboto', sans-serif;
  font-size: var(--font-size);
  color: var(--text);
  line-height: 1.5;
  padding: calc(var(--header-h) + 1rem) var(--pad-x)
           calc(var(--footer-h) + 0.6rem);
}
```

---

## Header bar

Marp creates a `<header>` element when `<!-- header: '…' -->` is set. Position it
absolutely so it sits above the flex content.

```css
section header {
  position: absolute;
  top: 0; left: 0;
  width: 100%; height: var(--header-h);
  background: var(--primary);
  color: var(--white);
  font-weight: 700; font-size: 1rem;
  padding: 0 var(--pad-x);
  display: flex; align-items: center;
  border-radius: 0 0 var(--radius) var(--radius);
  z-index: 10;
}
```

---

## Footer bar — three sections

`footer: '**A** **B** **C**'` in frontmatter renders as three `<strong>` children
inside `<footer>`. Each gets `flex: 1` to share width equally; the outer two get
distinct background shades.

```css
footer {
  position: absolute; bottom: 0; left: 0;
  width: 100%; height: var(--footer-h);
  background: var(--primary-dark);
  color: var(--white); font-size: 0.58rem;
  display: flex; align-items: center; z-index: 10;
}

footer > * {
  flex: 1; text-align: center;
  padding: 0 0.5rem;
  height: 100%; line-height: var(--footer-h);
  overflow: hidden; white-space: nowrap; text-overflow: ellipsis;
}

footer > *:first-child { text-align: left;  background: var(--primary-darker); }
footer > *:last-child  { text-align: right; background: var(--primary);
                          padding-right: 3.5rem; } /* space for page number */
```

Page number sits in `section::after`, absolutely positioned over the footer's
right end:

```css
section::after {
  content: attr(data-marpit-pagination) ' / ' attr(data-marpit-pagination-total);
  position: absolute; bottom: 0; right: 0.5rem;
  height: var(--footer-h); line-height: var(--footer-h);
  font-size: 0.58rem; color: var(--white); z-index: 11;
}
```

---

## Tables — shadow-column bug and fix

### What goes wrong

Themes like neobeam set `background-color` directly on the `<table>` element and
use `width: 100%` or `min-width: 40%`. When the table element is wider than its
actual column content, the table's own background bleeds into the empty space on
the right — it looks like a phantom column, often with the table's outer border
appearing as a dark bar.

### The fix

```css
table {
  border-collapse: collapse;  /* cells share borders — no inter-cell spacing */
  background: none;           /* NO background on table element */
  width: fit-content;         /* table is exactly as wide as its columns */
  max-width: 92%;
  font-size: 0.82em;
  margin: 0.5em 0;
}
```

Put backgrounds only on `th`, `td`, and `tr` — never on `table` itself:

```css
table th {
  background: var(--primary); color: var(--white);
  font-weight: 600; padding: 0.35em 0.9em;
  border: 1px solid var(--primary-dark); text-align: center;
}
table th:first-child { text-align: left; }

table td { padding: 0.35em 0.9em; border: 1px solid #d0d0e8; vertical-align: middle; }
table td:not(:first-child) { text-align: center; }
table tbody tr:nth-child(odd)  td { background: var(--white); }
table tbody tr:nth-child(even) td { background: var(--bg-stripe2); }
```

---

## Definition blockquotes — gap-line bug and fix

### The Marp syntax

```markdown
> #### Key Finding
> Body text of the finding or definition.
```

Marp renders this as a `<blockquote>` directly containing an `<h4>` and a `<p>`.
The CSS selector `blockquote:has(> h4)` targets this pattern.

### What goes wrong

When you apply `border-radius` to all four corners of both the `h4` and `p`
children (different background colours), the inward-curving corners at the shared
edge reveal the parent background — a visible seam appears between the title bar
and the body.

### The fix

Give `overflow: hidden` to the parent and `border-radius: 0` to the children.
The parent's border-radius clips the children cleanly at the corners; the children
don't need their own rounding.

```css
blockquote:has(> h4) {
  border: none; background: none; padding: 0;
  max-width: var(--defblock-width);
  border-radius: var(--radius);
  overflow: hidden;            /* clips children flush — no seam */
  display: flex; flex-direction: column;
  color: var(--white);
}

blockquote:has(> h4) h4 {
  background: var(--primary); color: var(--white);
  padding: 0.35em 0.8em; margin: 0;
  font-size: 0.88em; font-weight: 700;
  border-radius: 0;            /* parent handles top corners */
}

blockquote:has(> h4) p {
  background: var(--primary-dark); color: var(--white);
  padding: 0.55em 0.8em; margin: 0;
  line-height: 1.55; border-radius: 0;  /* parent handles bottom corners */
}
```

---

## Paragraph margin — specificity bug and fix

### What goes wrong

Slides that use a bold label paragraph (`**Label**`) immediately above a bullet list
show a large blank gap (~0.75 em) between them, even when no extra blank line exists
in the Markdown source.

### Root cause

The beamer theme resets all margins with `* { margin: 0; padding: 0 }`, but the
universal selector `*` has CSS specificity 0-0-0. Marp's built-in base stylesheet
contains `p { margin: 0.5em 0; }` at specificity 0-0-1 — it wins, so `<p>` elements
always retain a 0.5 em top/bottom margin. With `ul { margin: 0.25em 0 }` on top, the
total visible gap between a bold label and a bullet list is 0.75 em.

### The fix

Add an explicit `p` rule in the theme CSS, after the heading block:

```css
p { margin: 0.15em 0; }
```

The resulting label-to-list gap is ~0.4 em (0.15 + 0.25), which reads naturally
without collapsing distinct sections into each other.

---

## Standard blockquote (no h4)

```css
blockquote {
  border-left: 4px solid var(--primary-light);
  background: var(--bg-stripe2);
  padding: 0.4em 0.8em; margin: 0.5em 0;
  border-radius: 0 var(--radius) var(--radius) 0;
  max-width: var(--blockquote-width); color: var(--text);
}
```

---

## Title slide

```css
section.title {
  justify-content: center; align-items: center;
  text-align: center; padding: 2rem; gap: 0.8em;
}

section.title h1 {
  background: var(--primary); color: var(--white);
  padding: 0.5em 1.5em; border-radius: var(--radius);
  font-size: 1.6em; border-bottom: none; max-width: 85%;
}

section.title h2 { border-bottom: none; font-weight: 400; font-size: 1em; }
section.title h3 { font-weight: 300; font-size: 0.85em; color: #555; }

/* Reset blockquote to plain italic text on title slide */
section.title blockquote {
  all: unset; color: #555; font-style: italic; font-size: 0.9em;
}
```

---

## Centering utilities

Markdown has no text-alignment syntax. `![center]` works only because images have an `alt`
attribute CSS can target. Plain paragraphs render as bare `<p>` with nothing to hook onto.

The theme provides two utility classes:

| Class | Purpose |
|:------|:--------|
| `.center` | Centers text, inline content, **and** tables |
| `.caption` | Figure caption — centered, `0.78em`, grey |

```css
.center { text-align: center; }
.center table { margin-left: auto; margin-right: auto; }

.caption { text-align: center; font-size: 0.78em; color: #666; margin: 0.2em 0 0.5em; }
```

**Why `.center table` is needed:** `text-align: center` on a wrapper div centers inline
content but does NOT move a block-level `<table>`. Tables need `margin: auto` on the
element itself. `.center table` handles this automatically.

**Centering text or inline content:**
```markdown
<div class="center">Any text, emphasis, or inline elements here</div>
```

**Centering a figure caption:**
```markdown
![center w:500](figure.png)

<div class="caption">Figure 1. Predicted margins by year under surveillance</div>
```

**Centering a table — markdown tables cannot be wrapped in a `<div>`.** Use the
`center-table` class, which ships in the theme:
```markdown
<!-- _class: center-table -->

## Slide Title

| Col A | Col B |
|:------|:------|
| data  | data  |
```

All require `"markdown.marp.html": true` in `.vscode/settings.json`.

---

## Inline code chips — the table-stripe collision

Inline `` `code` `` renders as a chip: a filled, bordered box. It has its own three
tokens rather than borrowing a stripe colour, because of where chips end up:

```css
code {
  background: var(--code-bg);
  color: var(--code-fg);
  border: 1px solid var(--code-border);
}
```

**The failure this prevents.** A chip inside a table sits on top of the even-row
fill (`--bg-stripe2`), not on the white slide background. If the chip fill and the
row fill are the same hue at a similar lightness, the chip boundary disappears and
the code token reads as ordinary body text. This is easy to introduce without
noticing: it appears only on even rows, and only on slides where a chip lands
inside a table.

The original theme filled chips with `--bg-stripe` (`#ededf8`) against a
`--bg-stripe2` row (`#f5f5fc`), a lightness difference of roughly 3%. That is
invisible in practice. It was found on the APSA 2026 deck, where a monochrome
blue palette made the collision worse than in the default purple-blue.

**Two rules when recolouring:**

1. `--code-bg` must be clearly darker than `--bg-stripe2` — target at least a 10%
   lightness gap, and check the chip on an *even* table row, not on the slide
   background where it always looks fine.
2. Keep the border. It is what carries the chip edge when the fill and the row
   happen to be close, and it costs nothing when they are not.

A palette whose chips sit off the primary hue entirely (a warm sand chip on a blue
deck, for example) separates most strongly, at the cost of introducing a second
hue. Both readings are defensible; the monochrome one is the theme default because
it keeps an academic deck to a single colour family.

**Fenced code blocks** reuse the fill but drop the framing, since a multi-line
block does not need to read as an inline token:

```css
pre code { border: none; background: none; padding: 0; }
```

---

## Per-slide utility classes live in the theme

`section.small-text`, `.tight`, `.vcenter`, `.center-table`, `.small-table`,
`.wide-table`, `.large-text`, `.wide-defblock`, `.wide-quote` and `.fig-title` are
defined in `beamer.css` itself. A deck applies them with `<!-- _class: name -->`
and does **not** re-declare them in its frontmatter.

This was not always true. The first two decks built with this skill each carried
the same eight-line block of `section.*` rules copy-pasted into their frontmatter,
which meant a fix to one deck's spacing never reached the other. If a deck needs a
different value, override just that one rule in its `style:` block:

```yaml
style: |
  section.small-text { font-size: 18px; }   /* theme default is 19px */
```

---

## Customising the colour scheme

The theme uses 9 static hex colour tokens. Set all 9 together — changing only
`--primary` leaves every derived shade pointing at the old hue.

Override them via a `style:` block in the Marp frontmatter (no CSS file editing needed):

```yaml
---
marp: true
theme: beamer
style: |
  :root {
    --primary:        #3333b2;   /* header bar, table th, definition title, h2 underline */
    --primary-dark:   #25259e;   /* footer centre, definition body */
    --primary-darker: #1a1a80;   /* footer left segment */
    --primary-light:  #9999dd;   /* h2 underline, standard blockquote left border */
    --bg-stripe2:     #f5f5fc;   /* table even rows, blockquote background */
    --code-bg:        #e2e2f4;   /* inline code chip fill */
    --code-fg:        #22226b;   /* inline code chip text */
    --code-border:    #c2c2e6;   /* inline code chip border */
    --table-border:   #d0d0e8;   /* table cell borders */
  }
---
```

Remove the `style:` block entirely to revert to default blue. Always include all
9 tokens — partial overrides leave mismatched shades.

**The two easily-forgotten ones are `--code-bg` and `--table-border`**, because
both were hardcoded in early versions of the theme. A deck that omits them gets
blue-purple cell borders and a blue code chip on an otherwise purple or gold deck.
`--muted` and `--caption-fg` are hue-neutral greys and rarely need touching.

**Why static hex, not computed HSL:** CSS relative color syntax (`hsl(from var(…)`)
requires Chrome 119+. Static tokens work in all Chromium versions Marp might use,
and allow exact matching to a reference palette rather than algorithmic approximation.

**Preset palettes:**

| Scheme | `--primary` | `--primary-dark` | `--primary-darker` | `--primary-light` | `--bg-stripe2` | `--code-bg` | `--code-fg` | `--code-border` | `--table-border` |
|--------|-------------|------------------|--------------------|-------------------|----------------|-------------|-------------|-----------------|------------------|
| Beamer blue (default) | `#3333b2` | `#25259e` | `#1a1a80` | `#9999dd` | `#f5f5fc` | `#e2e2f4` | `#22226b` | `#c2c2e6` | `#d0d0e8` |
| SCNU / conference blue | `#1B5FA8` | `#154A85` | `#0F3663` | `#5B9BD5` | `#F5F9FD` | `#DCE7F6` | `#10406F` | `#B4CCE6` | `#CFE0F0` |
| CUHK purple & gold | `#73216d` | `#5a1957` | `#3f1240` | `#dda300` | `#faf4e8` | `#f4dfb0` | `#5a3a06` | `#dcc084` | `#e5d8e4` |
| Dark teal | `#1a6b5c` | `#145246` | `#0d3830` | `#7bbcb0` | `#f0faf8` | `#dcefeb` | `#0d3830` | `#b3d8d1` | `#c4e0da` |
| Burgundy | `#7a1a2e` | `#621524` | `#4a0f1a` | `#c47a8a` | `#faf0f2` | `#f2dde1` | `#4a0f1a` | `#dfb9c1` | `#e6cdd3` |
| Slate grey | `#3d4f6b` | `#2f3e56` | `#202c3f` | `#8d9db5` | `#f3f4f7` | `#e4e7ed` | `#202c3f` | `#c8cedb` | `#d5dae2` |

### Deriving a palette from one institutional colour

Both decks built with this skill took their palette from a university's identity
guidelines. The procedure is mechanical once you have the primary hex:

| Token | How to derive |
|-------|---------------|
| `--primary` | The institution's primary colour, taken from its identity guidelines rather than sampled from a logo JPEG |
| `--primary-dark` | `--primary` at ~85% lightness |
| `--primary-darker` | `--primary` at ~70% lightness |
| `--primary-light` | The institution's *secondary* colour if it has one (CUHK gold `#dda300`), otherwise `--primary` lightened to ~65% |
| `--bg-stripe2` | `--primary` at ~4% saturation — a barely-there tint for table rows |
| `--code-bg` | `--primary` at ~15% saturation, or the secondary colour heavily lightened. Check it against `--bg-stripe2`, see "Inline code chips" above |
| `--code-fg` | `--primary-darker`, or a dark neutral of the chip's own hue |
| `--code-border` | Midway between `--code-bg` and `--code-fg`, closer to the fill |
| `--table-border` | `--primary` at ~12% saturation — visible as a grid line, never as a colour |

CUHK is the useful worked example because it has two brand colours: purple carries
the structural furniture (header, footer, table headers) and gold carries the
accents (h2 underline, blockquote border, code chips). A single-colour institution
gives the monochrome variant instead, as in the SCNU blue row above, and there the
chip contrast rule matters much more.

To generate a custom palette from a reference image or brand colour, share the
hex/image with Claude and ask for a full token block.
