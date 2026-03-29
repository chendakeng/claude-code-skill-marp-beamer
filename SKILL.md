---
name: marp-beamer
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

---

## Critical rules — internalize before writing anything

These are the two bugs that reliably appear when building beamer-style themes for
Marp. They look subtle on screen but have simple root causes.

### 1 — Table shadow column

**Symptom:** A phantom column (same background as table, no text) appears to the
right of the last real column, with a dark border on the far right.

**Cause:** Putting `background-color` on the `<table>` element itself. When the
table element is wider than its cell columns, the table's own background bleeds
into the empty space.

**Fix — three properties, always together:**
```css
table {
  border-collapse: collapse; /* cells share borders, no gaps */
  background: none;          /* no background on table element — only on th/td */
  width: fit-content;        /* table is exactly as wide as its columns */
}
```

Never put `background-color` directly on `table`. Put it only on `th`, `td`, and `tr`.

### 2 — Definition-block gap line

**Symptom:** A thin visible seam between the coloured title bar (h4) and the body
of a `blockquote:has(> h4)` definition block.

**Cause:** Applying `border-radius` to all four corners of both the `h4` and `p`
children. Where their adjacent edges meet, the inward-curving corners reveal the
parent's background, creating the seam.

**Fix — `overflow: hidden` on the parent, `border-radius: 0` on children:**
```css
blockquote:has(> h4) {
  border-radius: var(--radius);
  overflow: hidden;   /* clips children flush — no seam possible */
}
blockquote:has(> h4) h4 { border-radius: 0; }
blockquote:has(> h4) p  { border-radius: 0; }
```

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
