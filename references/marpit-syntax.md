# Marpit Syntax Reference

## Slide separator

Slides are split by a horizontal ruler. An empty line before `---` is required
by the CommonMark spec. Alternatives: `___`, `***`, `- - -`.

```markdown
# Slide 1
Content.

---

# Slide 2
More content.
```

---

## Frontmatter (global settings)

Must be the very first block in the file.

```yaml
---
marp: true
theme: beamer          # must match @theme name in the CSS file
paginate: true
math: katex            # or mathjax
footer: '**Author** **Title** **Venue · Date**'
---
```

The footer value uses Markdown bold segments (`**…**`) — Marp renders each as a
`<strong>` child inside `<footer>`, which the CSS styles as three sections.

---

## Directives

Directives are YAML instructions placed inside HTML comments. Three scopes:

| Scope | Syntax | Applies to |
|-------|--------|------------|
| Global | `<!-- theme: beamer -->` | Whole deck (last value wins) |
| Local | `<!-- header: 'Methods' -->` | This slide and all after it |
| Spot | `<!-- _class: title -->` | This slide only (underscore prefix) |

### Common directives

```markdown
<!-- header: 'Section name' -->     header bar text (local)
<!-- footer: '...' -->              override footer (local)
<!-- class: two-col -->             add CSS class to <section> (local)
<!-- backgroundColor: #f0f0f0 -->  slide background colour (local)
<!-- backgroundImage: url(...) -->  background image (local)
<!-- backgroundSize: cover -->      cover / contain / auto (local)
<!-- color: #333 -->                text colour override (local)
<!-- paginate: true -->             show page numbers (local)
```

Spot equivalents: prefix any of the above with `_`:

```markdown
<!-- _class: title -->       this slide only
<!-- _header: '' -->         blank header on this slide only
<!-- _backgroundColor: aqua -->
```

### Per-slide element styling with `_class`

**`_style` is NOT a valid Marp directive** — it is silently ignored. Only specific
directives support the `_` spot prefix (`_class`, `_header`, `_footer`,
`_backgroundColor`, etc.). `style` is frontmatter-only and applies globally.

To style one slide only, apply a class with `<!-- _class: name -->`. The theme
ships nine: `small-text`, `large-text`, `tight`, `vcenter`, `center-table`,
`small-table`, `wide-table`, `wide-defblock`, `wide-quote`.

For anything they do not cover, define a class in the deck's frontmatter — scoped
to `section.classname`, or the rule bleeds to every slide:

```yaml
style: |
  section.dense table { font-size: 0.7em; }
```

```markdown
<!-- _class: wide-defblock -->

> #### Wide Finding Block
> This definition block stretches full width on this slide only.
```

The `section.classname` prefix is required — it scopes the rule to slides with
that class and prevents it from affecting other slides.

### Pagination values

| Value | Shows number | Counter increments |
|-------|--------------|--------------------|
| `true` | yes | yes |
| `false` | no | yes |
| `hold` | yes | no |
| `skip` | no | no |

### headingDivider — auto-split at headings

```yaml
---
headingDivider: 2   # split at every ## heading
---
```

---

## Image syntax

Marp extends standard Markdown image syntax with keywords in the **alt text**.

### Resizing

```markdown
![w:400px](image.png)
![w:50% h:300px](image.png)
![w:32 h:32](image.png)        # unitless = px
```

### Inline alignment

```markdown
![left Caption](image.png)     # float left
![right Caption](image.png)    # float right
![center Caption](image.png)   # centre
```

### Centering text, captions, and tables

Marp has no `[center]` equivalent for text — `![center]` works only because images have
an `alt` attribute CSS can target. The beamer theme provides two utility classes:

**`.center`** — centers text, inline content, and tables:
```markdown
<div class="center">Any centered text here</div>
```

**`.caption`** — figure caption style (centered, small, grey):
```markdown
![center w:500](figure.png)

<div class="caption">Figure 1. Caption text here</div>
```

**Centering a markdown table** — tables cannot be wrapped in a `<div>`. Apply
`<!-- _class: center-table -->` on the slide; the class ships in the theme.

All require `"markdown.marp.html": true` in `.vscode/settings.json`.

---

### Background images (consume no inline space)

```markdown
![bg](image.png)                # fills slide (default: cover)
![bg cover](image.png)
![bg contain](image.png)        # fit inside slide
![bg left](image.png)           # left half; content in right half
![bg left:33%](image.png)       # left 33%; content in 67%
![bg right](image.png)          # right half; content in left half
![bg right:40%](image.png)
```

Multiple `![bg]` images stack horizontally; use `vertical` to stack vertically:

```markdown
![bg vertical](a.png)
![bg vertical](b.png)
```

### Side-by-side images (horizontal row)

The beamer theme sets `img { display: block; }`, so images placed next to each
other in Markdown always stack **vertically**. To force a horizontal row, use
`<img>` tags directly inside a flex container — do NOT use Markdown `![]()` syntax
here, as Marp wraps each in a `<p>` block regardless of blank lines:

```markdown
<div style="display: flex; gap: 1rem; justify-content: center;"><img src="image1.png" width="300"/><img src="image2.png" width="300"/></div>
```

Key points:
- Use raw `<img>` tags, not Markdown `![]()` — Marp always wraps `![]()` in a
  block element, breaking flex layout.
- The beamer CSS includes `div img { display: inline; margin: 0; }` so `<img>`
  tags inside any `<div>` automatically become flex children — no extra style needed.
- Keep everything on one line — line breaks inside the `<div>` can introduce
  unwanted whitespace nodes.
- Adjust `gap` for spacing; `justify-content` (`flex-start`, `center`,
  `space-between`) for alignment.
- Each `<img>` can have its own independent `width`.

---

### CSS filters

```markdown
![blur:5px](image.png)
![brightness:.8 sepia:50%](image.png)
![grayscale](image.png)
```

---

## Math

```yaml
---
math: katex   # or mathjax
---
```

```markdown
Inline: $E = mc^2$

Display:
$$\frac{d}{dx}\int_a^x f(t)\,dt = f(x)$$
```

---

## HTML

Enable in `.vscode/settings.json`:

```json
{
    "markdown.marp.html": true
}
```

Then use HTML elements directly in slide bodies. Restart VS Code after changing
this setting.

---

## VS Code setup

**`.vscode/settings.json`** (project root) — registers the custom CSS theme and
enables HTML:

```json
{
    "markdown.marp.themes": [
        ".vscode/beamer.css"
    ],
    "markdown.marp.html": true
}
```

After editing `settings.json` or the CSS file, run **Cmd+Shift+P → Reload Window**
to force Marp to pick up the changes. Theme name in frontmatter must exactly match
the `@theme` name in the CSS comment header.

---

## Rendering from the CLI

```bash
marp --no-stdin deck.md --allow-local-files \
  --theme-set /abs/path/to/.vscode/beamer.css \
  --pdf -o deck.pdf
```

**`--no-stdin` is mandatory outside an interactive terminal.** When stdin is not a
TTY, which is the case for every agent tool call, `marp` first waits to read Markdown
from stdin (it logs "Currently waiting data from stdin stream" only at INFO level). If
nothing closes stdin, the call sits there until the tool times out and looks like a slow
or failed render. Verified 2026-10-11: one call hung past 120 s; the same deck with
`--no-stdin` rendered in 3 s.

**`--theme-set` is mandatory.** The Marp CLI does not read
`.vscode/settings.json` — `markdown.marp.themes` is understood by the VS Code
extension only. Omit the flag and the CLI silently falls back to Marp's generic
default theme: no header bar, no footer, wrong colours, and **exit code 0**. A
clean exit is not evidence the render worked. Open the PDF and look at it.

Other flags worth knowing:

| Flag | Why |
|------|-----|
| `--allow-local-files` | Required whenever the deck references local images. Prints an insecure-access warning; that warning is expected, not an error |
| `--images png` | Renders every slide to a numbered PNG (`out.001.png`, …). 4 s for a 50-slide deck with 26 figures when run with `--no-stdin`. The earlier measurement of "over 2 minutes" was almost certainly the stdin wait, not rendering |
| `--html` | HTML export, under 1 s for 51 slides. Used for the fast preview below and for presenter mode. Images stay linked relative to the HTML, so write it next to the deck |

### Checking slides quickly

Re-measured 2026-10-11 on a 50-slide deck with 26 figures, all with `--no-stdin`:

| Method | Time | Use for |
|--------|------|---------|
| `--html` | under 1 s | Opening the whole deck in a browser |
| `--images png -o /scratch/p.png` | 4 s | **The edit-and-check loop.** Render everything, view only the changed pages |
| `--pdf` | 3 s | Final check before distribution |
| `scripts/preview_slide.sh` | 2 s | One slide as a headless-Chrome screenshot (was 15–25 s before it gained `--no-stdin`). Use when a slide must be checked exactly as Chrome shows it |

The older figures in this section (PDF about 50 s, PNG over 2 minutes) were taken without
`--no-stdin` and measured the stdin wait, not rendering.

```bash
# Edit-and-check loop: render every slide, then look only at the pages you changed
marp --no-stdin deck.md --allow-local-files \
  --theme-set /abs/path/to/.vscode/beamer.css \
  --images png -o /scratch/p.png        # writes /scratch/p.001.png, p.002.png, …
```

File numbers count from the title slide, so with `_paginate: skip` on the title slide the
footer page number N is file N+1.

```bash
~/.claude/skills/claude-code-skill-marp-beamer/scripts/preview_slide.sh \
  deck.md SLIDE_INDEX /abs/path/to/.vscode/beamer.css /scratch/out.png
```

The script needs the `marp` CLI and Google Chrome. Set `CHROME_BIN` for a Chrome installed elsewhere.

- **SLIDE_INDEX counts from the title slide.** If the title slide has `_paginate: skip`, the
  footer page number N is index N+1.
- **Write scripts to disk with the file-writing tool, not a shell heredoc.** A heredoc containing
  quotes and `$` was mangled by the harness and the call hung.
- **The screenshot shows Marp's navigation bar** (a gray pill at the bottom center). It can cover
  the last line of a slide. Judge overflow by the text above it, or open the HTML in a browser.
- **No render error was ever the deck's fault in this pipeline.** The apparent "slow renders"
  were `marp` waiting on stdin. A non-zero exit from `marp` is the only real failure signal.

For styling work on one slide's CSS, extract that slide plus the frontmatter into a scratch `.md`
and render that instead.

### Theme copies in sub-workspace folders

A project keeps `beamer.css` at its root in `.vscode/`. If a subfolder (a
conference folder, say) is ever opened as its own VS Code workspace, the extension
looks for `.vscode/` relative to *that* folder and finds nothing. Mirror both
`beamer.css` and `settings.json` into the subfolder's own `.vscode/`.

The mirrored copy is a copy, so it can drift. When changing the theme, change
every copy in the project in the same pass, and keep them identical to the
skill's `assets/beamer.css` apart from deliberate, documented differences.

---

## Speaker notes

Speaker notes are written as HTML comments at the end of each slide's content
block. They are invisible on the slide but appear in presenter mode.

```markdown
## Slide Title

Content visible on the slide.

<!--
This is a speaker note.
Write the full speech text here — as many lines as needed.
It does not appear on the slide.
-->
```

### Presenter mode

Export as HTML (VS Code Marp extension → Export → `.html`), open in a browser,
press **`P`**. You will see:

- Current slide (left) · Next slide preview (right)
- Speaker notes panel (below)
- Elapsed timer

The HTML file is self-contained — no server needed.

### Practical pattern for talk scripts

Write the full spoken script as speaker notes, one slide at a time. For optional
content (e.g. self-introduction that depends on context), wrap it in backticks
inside the note so it reads as conditional:

```markdown
## Title

<!--
`Optional: Good morning, my name is…`

Today I want to show you how my research and teaching come together.
-->
```

### What does NOT work

| Attempt | Result |
|:--------|:-------|
| `<!-- note: text -->` | Not a Marp directive — ignored |
| Notes in PDF export | PDF has no presenter mode — notes are lost; use HTML |
