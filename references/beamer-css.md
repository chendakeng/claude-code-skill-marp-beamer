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

@import url('https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap');
@import "default";   /* Marp's base reset — always import this */
```

`@auto-scaling true` lets Marp shrink text that overflows a slide.
`@size` sets the slide canvas dimensions.

---

## Design tokens

All colours and spacing in `:root` — change `--primary` to recolour the whole theme.
Classic beamer blue is `#3333b2`.

```css
:root {
  --primary:        #3333b2;
  --primary-dark:   #25259e;
  --primary-darker: #1a1a80;
  --bg-stripe2:     #f5f5fc;   /* even-row table tint */
  --text:           #111122;
  --white:          #ffffff;
  --header-h:  2.4rem;
  --footer-h:  1.4rem;
  --pad-x:     2.5rem;
  --radius:    0.45rem;
  --font-size: 22px;
}
```

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
table th:first-child { text-align: left; border-radius: var(--radius) 0 0 0; }
table th:last-child  { border-radius: 0 var(--radius) 0 0; }

table td { padding: 0.35em 0.9em; border: 1px solid #d0d0e8; }
table td:not(:first-child) { text-align: center; }
table tbody tr:nth-child(odd)  td { background: var(--white); }
table tbody tr:nth-child(even) td { background: var(--bg-stripe2); }
table tbody tr:last-child td:first-child { border-radius: 0 0 0 var(--radius); }
table tbody tr:last-child td:last-child  { border-radius: 0 0 var(--radius) 0; }
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
  max-width: 62%;
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

## Standard blockquote (no h4)

```css
blockquote {
  border-left: 4px solid var(--primary);
  background: var(--bg-stripe2);
  padding: 0.4em 0.8em; margin: 0.5em 0;
  border-radius: 0 var(--radius) var(--radius) 0;
  max-width: 90%; color: var(--text);
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

## Customising the colour scheme

Change only `--primary` in `:root` and all derived colours update automatically:

| Want | Set `--primary` to |
|------|-------------------|
| Classic beamer blue | `#3333b2` (default) |
| Dark teal | `#1a6b5c` |
| Burgundy | `#7a1a2e` |
| Slate grey | `#3d4f6b` |

Then manually adjust `--primary-dark` (slightly darker) and `--primary-darker`
(darkest) to match.
