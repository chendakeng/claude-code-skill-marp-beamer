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
other in Markdown always stack **vertically**. To force a horizontal row, wrap
them in a flex container:

```markdown
<div style="display: flex; gap: 1rem; justify-content: center;">

![w:300](image1.png)
![w:300](image2.png)

</div>
```

Key points:
- The blank lines inside the `<div>` are required — Marp needs them to parse
  the image syntax correctly.
- Adjust `gap` for spacing between images; adjust `justify-content` (`flex-start`,
  `center`, `space-between`) for alignment.
- Each image can have its own independent `w:` size.

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
