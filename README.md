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

```bash
# Clone into your Claude skills directory
git clone https://github.com/chendakeng/claude-code-skill-marp-beamer \
    ~/.claude/skills/marp-beamer
```

Or symlink from a local path:

```bash
ln -sf /path/to/skill_marp_beamer ~/.claude/skills/marp-beamer
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
   ---
   ```

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

## Reference

- [Marp](https://marp.app/) — Markdown Presentation Ecosystem
- [Marpit documentation](https://marpit.marp.app/) — directive and image syntax
- [neobeam](https://github.com/mikael-ros/neobeam) — original inspiration for the colour scheme and layout
