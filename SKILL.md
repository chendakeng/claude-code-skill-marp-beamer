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
  → Define section.classname { ... } in frontmatter style:
  → Apply with <!-- _class: classname --> on that slide
  → Multiple classes are space-separated
  → Examples: section.small-text, section.wide-table, section.center-table

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

## Critical CSS design rules

Three areas of the beamer CSS require non-obvious rules. Each rule is intentional:
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

## Quick-start checklist for a new deck

1. Copy `assets/beamer.css` → `.vscode/beamer.css` in the project
2. Create `.vscode/settings.json`:
   ```json
   { "markdown.marp.themes": [".vscode/beamer.css"], "markdown.marp.html": true }
   ```
3. Reload VS Code window (`Cmd+Shift+P → Reload Window`)
4. Add frontmatter: `marp: true`, `theme: beamer`, `paginate: true`, `footer: '**Author** **Title** **Venue**'`
5. First slide: `<!-- _class: title -->`
6. Each section: `<!-- header: 'Section Name' -->` (local — persists forward)
7. Blank header on one slide: `<!-- _header: '' -->` (spot — this slide only)
