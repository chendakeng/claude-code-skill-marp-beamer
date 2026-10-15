---
name: skill_marp_beamer
description: >
  Creates and edits Marp presentations with a beamer-style theme (dark-blue
  header bar, three-section footer, definition blocks, styled tables). Use this
  skill whenever the user is working on a Marp slide deck — whether writing
  slides from scratch, fixing CSS bugs (shadow columns, gap lines), setting up
  VS Code for Marp, customising colours or layout, or asking about any Marp /
  Marpit directive or image syntax. Trigger even if the user just says "make me
  some slides" or "I need a presentation" and they're in a Marp project.
---

# Marp Beamer Skill

## How to use this skill

Read only the reference file(s) relevant to the current task. Do not load all files.

| Task | Read |
|------|------|
| Writing slide content, using directives, images, math | `references/marpit-syntax.md` |
| Building or debugging the beamer CSS theme | `references/beamer-css.md` |
| Generating a new deck or slide from a template | `references/slide-templates.md` |
| Setting up VS Code + registering the theme | `references/marpit-syntax.md` (§ VS Code setup) |
| Copying the ready-to-use CSS file | `assets/beamer.css` |
| Recolouring a deck for an institution | `references/beamer-css.md` (§ Customising the colour scheme) |
| Rendering to PDF/PNG from the terminal | `references/marpit-syntax.md` (§ Rendering from the CLI) |
| Checking slides after an edit | `marp --no-stdin … --images png` into a scratch folder, then view the changed pages (see § Rendering from the CLI) |
| Appendix TOC with clickable links + back buttons | `references/slide-templates.md` (§ Appendix navigation) |
| Speaker notes + presenter mode | `references/marpit-syntax.md` (§ Speaker notes) |

---

## Customisation hierarchy — internalize this first

Every visual tweak in a Marp beamer deck operates at one of three levels.
Always pick the narrowest scope that satisfies the need.

```
Level 1 — Deck-wide (all slides)
  → Override :root tokens in the frontmatter style: block
  → Affects every slide simultaneously
  → Examples: --font-size, --pad-x, --primary, --table-max-width

Level 2 — Per-slide (one slide only)
  → Apply a class with <!-- _class: classname --> on that slide
  → Nine ship in the theme: small-text, large-text, tight, vcenter,
    center-table, small-table, wide-table, wide-defblock, wide-quote
  → Multiple classes are space-separated
  → Define section.classname { ... } in frontmatter style: ONLY for what
    those nine do not cover, or to change one of their values

Level 3 — Inline (specific element, word, or line)
  → Use <span style="..."> for words/phrases
  → Use <div class="center">, <div class="caption"> for block-level
  → Requires "markdown.marp.html": true in .vscode/settings.json
```

**Critical constraint:** `:root` variable overrides do NOT work inside `_class`
rules — Marp does not re-evaluate CSS custom properties at section scope.
Target elements directly instead:

```yaml
# WRONG — has no effect:
section.my-slide { --font-size: 18px; }

# CORRECT — targets element directly:
section.my-slide { font-size: 18px; }
section.my-slide table { font-size: 0.7em; }
```

---

## Fonts: local only, chosen by the deck's `lang:`

| Deck frontmatter | Body font (Mac → Windows → fallback) |
|------------------|---------------------------------------|
| `lang: en-US` | Times New Roman (English text and its “quotes”) → Georgia → serif; Chinese characters inside fall to Songti SC / SimSun |
| `lang: zh-CN` | 宋体 for everything, including “” ‘’ …… : Songti SC → STSong → SimSun → Noto/Source Han Serif → PingFang SC / Microsoft YaHei → serif |
| `lang: zh-TW` / `zh-HK` | Songti TC → PMingLiU → … → PingFang TC / Microsoft JhengHei |
| code | Menlo → Consolas → Courier New |

- **Always set `lang:` explicitly.** Without it, Marp uses the build machine's OS locale, so the
  same deck can come out in Times on one machine and 宋体 on another.
- **Never add a web font or CDN `@import`.** On mainland and campus networks the request hangs rather
  than fails, and an exported HTML deck stays blank until it times out. PDF builds hide this.
  When a project copied an older `beamer.css`, check its first lines for `@import url(` and remove it.
- **Use `math: mathjax`, not `katex`.** KaTeX loads its fonts from `cdn.jsdelivr.net`: with remote
  hosts blocked, a test deck took 24.5 s to load against 0.5 s for MathJax, which inlines SVG.
- To change a deck's face, override `--font-en` or `--font-zh` in `:root`, not `section { font-family }`
  (the `:lang()` rules outrank a plain `section` rule).

## Critical CSS design rules

Four areas of the beamer CSS require non-obvious rules. Each rule is intentional:
changing or removing it breaks the visual output in a way that is not immediately
obvious from the CSS alone.

### 1 — Tables: background only on cells, never on the table element

Tables need three properties together so the table element occupies exactly the
width of its columns and carries no background of its own:

```css
table {
  border-collapse: collapse; /* cells share borders, no gaps */
  background: none;          /* background on th/td only — never on table */
  width: fit-content;        /* table is exactly as wide as its columns */
}
```

If `background` is placed on `table` instead of the cells, or if `width` is set to
`100%`, a phantom column with a dark border appears to the right of the last real
column.

### 2 — Definition blocks: `overflow: hidden` on the parent, `border-radius: 0` on children

The `blockquote:has(> h4)` definition block has rounded corners. The correct pattern
is to round only the parent container and let `overflow: hidden` clip the children
flush to those corners:

```css
blockquote:has(> h4) {
  border-radius: var(--radius);
  overflow: hidden;   /* clips children flush — clean corner at the shared edge */
}
blockquote:has(> h4) h4 { border-radius: 0; }
blockquote:has(> h4) p  { border-radius: 0; }
```

If `border-radius` is applied to the child elements instead, the inward-curving
corners at the shared h4/p edge expose the parent background as a visible seam.

### 3 — Paragraph margins: use an explicit `p` rule, not the `*` reset

The CSS includes `* { margin: 0; padding: 0 }`, but the universal selector `*` has
specificity 0-0-0. Marp's built-in stylesheet ships with `p { margin: 0.5em 0 }` at
specificity 0-0-1, so it always wins over `*`. Without an explicit `p` rule in the
theme, paragraphs carry a 0.5 em top/bottom margin and a bold-label paragraph above
a bullet list produces a ~0.75 em gap.

The correct pattern is an explicit `p` rule at element specificity:

```css
p { margin: 0.15em 0; }
```

This sits after the heading block in the CSS and overrides Marp's built-in at equal
specificity via cascade order. The result is ~0.4 em spacing between a label and the
list below it — tight enough to look grouped, loose enough to breathe.

---

### 4 — Inline code chips have their own tokens, and keep their border

```css
code {
  background: var(--code-bg);
  color: var(--code-fg);
  border: 1px solid var(--code-border);
}
```

A chip inside a table sits on the even-row fill (`--bg-stripe2`), not on the white
slide background. If the two are the same hue at a similar lightness, the chip
vanishes and the code token reads as body text. The chip therefore gets tokens of
its own rather than borrowing a stripe colour, and the border stays so the edge
survives even when the fills are close.

When recolouring a deck, set `--code-bg` clearly darker than `--bg-stripe2` and
verify on an *even* table row. Details and the palette recipe:
`references/beamer-css.md`.

The same failure had a second instance: table cell borders were hardcoded
`#d0d0e8`, so every recoloured deck patched them by hand in its frontmatter. They
are now `--table-border`. **Any colour a palette should control must be a token** —
a hardcoded hex in the theme becomes a per-deck workaround that each deck has to
rediscover.

---

## Quick-start checklist for a new deck

1. Copy `assets/beamer.css` → `.vscode/beamer.css` in the project
2. Create `.vscode/settings.json`:
   ```json
   { "markdown.marp.themes": [".vscode/beamer.css"], "markdown.marp.html": true }
   ```
3. Reload VS Code window (`Cmd+Shift+P → Reload Window`)
4. Add frontmatter: `marp: true`, `theme: beamer`, `lang: zh-CN` or `en-US`, `math: mathjax`, `paginate: true`, `footer: '**Author** **Title** **Venue**'`.
   **No `# comments` on directive lines**: Marp keeps them as part of the value, which silently
   drops `theme:` and corrupts `lang:`
5. Add a palette to the frontmatter `style:` block — 9 colour tokens, all together
   (`references/beamer-css.md` § Customising the colour scheme). Nothing else
   belongs there: the `section.*` utility classes are already in the theme.
6. First slide: `<!-- _class: title -->`
7. Each section: `<!-- header: 'Section Name' -->` (local — persists forward)
8. Blank header on one slide: `<!-- _header: '' -->` (spot — this slide only)
9. Render with `--no-stdin` and `--theme-set` pointing at the CSS. Without
   `--no-stdin`, a non-terminal shell (any agent tool call) leaves `marp` waiting
   on stdin with no error; without `--theme-set` the CLI ignores `settings.json`
   and falls back to a generic theme with exit code 0
10. Check slides after each edit by rendering `--images png` into a scratch folder
    and viewing the changed pages: 4 s for a 50-slide deck

**If the deck lives in a subfolder that may be opened as its own VS Code
workspace, mirror `.vscode/beamer.css` and `.vscode/settings.json` into it too.**

---

## Where a change belongs

The recurring judgment call in this skill. Answer it before writing CSS anywhere.

| The change is… | Put it in |
|----------------|-----------|
| Structural, or any `section.*` utility class | `assets/beamer.css`, then sync every project copy |
| This deck's colours, body font (`--font-en` / `--font-zh`), or a token value this deck alone needs | The deck's frontmatter `style:` block |
| One word or phrase on one slide | Inline `<span style="…">` |

A `section.*` rule appearing in a deck's frontmatter means the rule belongs in the
theme. Two decks that both need it will otherwise drift apart, and a fix to one
never reaches the other. This happened with the first two decks built on this
skill: both carried the same eight copy-pasted utility rules until they were
promoted into `beamer.css`.
