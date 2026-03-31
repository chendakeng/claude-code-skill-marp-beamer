# Slide Templates

## Full deck template

Copy this as your starting `.md` file. Replace placeholders in `[]`.

```markdown
---
marp: true
theme: beamer
paginate: true
math: katex
footer: '**[Author Name]** **[Presentation Title]** **[Venue · Date]**'
style: |
  :root {
    /* ── Colour palette (change --primary to recolour everything) ── */
    --primary:        #3333b2;   /* header bar, table headers, definition title, h2 underline */
    --primary-dark:   #25259e;   /* footer centre, definition body */
    --primary-darker: #1a1a80;   /* footer left segment */
    --primary-light:  #9999dd;   /* h2 underline, standard blockquote left border */
    --bg-stripe:      #ededf8;   /* inline code background */
    --bg-stripe2:     #f5f5fc;   /* table even rows, standard blockquote background */

    /* ── Layout & typography ── */
    --font-size:  22px;    /* base text size */
    --pad-x:      2.5rem;  /* left/right content padding */
    --header-h:   2.4rem;  /* top header bar height */
    --footer-h:   1.4rem;  /* bottom footer bar height */
    --radius:     0.45rem; /* border radius everywhere */

    /* ── Element widths ── */
    --defblock-width:   88%;  /* definition block: > #### Title */
    --table-max-width:  92%;  /* tables */
    --blockquote-width: 90%;  /* standard blockquotes */
    --img-max-width:    80%;  /* inline images */
    --title-h1-width:   85%;  /* title-slide h1 box */
  }

  /* ── Per-slide overrides (apply with <!-- _class: name -->) ──
     Rules MUST be scoped with section.classname to avoid bleeding.
     _style is NOT a valid Marp directive — use _class instead.
     :root variable overrides do NOT work inside _class rules.       */
  section.wide-defblock blockquote:has(> h4) { max-width: 100%; }
  section.wide-table table { max-width: 100%; width: 100%; }
  section.small-table table { font-size: 0.7em; }
  section.center-table table { margin: 0.5em auto; }
  section.small-text { font-size: 18px; }
  section.large-text { font-size: 26px; }
  section.tight { line-height: 1.3; }
  section.tight ul, section.tight ol { line-height: 1.5; }
  section.vcenter { justify-content: center; }
  section.wide-quote blockquote { max-width: 100%; }
---

<!-- _class: title -->

# [Presentation Title]

## [Author Name]

> [Affiliation · Institution]

### [Venue · Date]

---

<!-- header: '[Section 1 Name]' -->

## [Slide Title]

Body text and bullet points.

- Key point one
- Key point two
  - Sub-point

---

<!-- header: '[Section 1 Name]' -->

## [Table Slide Title]

| Metric | Group A | Group B | Group C |
|--------|:-------:|:-------:|:-------:|
| Row 1  | 77%     | 63%     | 29%     |
| Row 2  | 91%     | 100%    | 100%    |

---

<!-- header: '[Section 1 Name]' -->

## [Finding Slide Title]

Supporting text before the finding.

> #### [Finding Title]
> Core finding stated in one or two sentences. Keep it punchy.

---

<!-- header: '[Section 2 Name]' -->

## [New Section Slide]

Content continues here.

---

<!-- _class: title -->

# Thank You

## Questions Welcome

> *[One-sentence closing message or key takeaway.]*
```

---

## Individual slide patterns

### Title slide

```markdown
<!-- _class: title -->

# Talk Title

## Speaker Name

> Affiliation · Department

### Conference Name · Month Year
```

The `blockquote` on a title slide renders as plain italic text (the CSS uses
`all: unset` for `section.title blockquote`).

---

### Content slide with mixed elements

```markdown
<!-- header: 'Section Name' -->

## Slide Title

**Bold lead-in** — body sentence continues here.

- First bullet
- Second bullet with **emphasis**

> Short pullquote or methodological note.
```

---

### Table slide

Marp column alignment: `:---` left, `:---:` centre, `---:` right.

```markdown
<!-- header: 'Evidence' -->

## Results

| Response Pattern                | Citizens | Officials | Police |
|---------------------------------|:--------:|:---------:|:------:|
| Felt psychological pressure     | 77%      | 63%       | 29%    |
| Became more compliant           | 91%      | 100%      | 100%   |
| Habituated over time            | 86%      | 100%      | 100%   |
```

---

### Definition / key finding block

```markdown
> #### Key Finding
> Initial surveillance significantly boosts compliance; effect diminishes within
> ~2 years and cannot be restored by reinforcement.
```

The `> #### Title` syntax triggers the styled definition block (dark header bar +
coloured body, no seam). Only use `####` (h4) inside a blockquote for this effect.

---

### Split layout with background image

```markdown
<!-- header: 'Case Study' -->

## City-Level Variation

![bg left:40% contain](map.png)

- Point about the left panel
- Another data point
- Third observation
```

`left:40%` reserves 40% of the slide width for the background image; content
fills the remaining 60%.

---

### Math slide

```markdown
<!-- header: 'Model' -->

## Compliance Decay Function

Compliance at time $t$ after surveillance deployment:

$$C(t) = C_0 \cdot e^{-\lambda t} + \epsilon$$

Where $\lambda$ is the habituation rate and $\epsilon$ is residual compliance.
```

Requires `math: katex` in frontmatter.

---

### Blank header on one slide

Use the spot directive (`_`) to override the header for a single slide without
affecting subsequent slides:

```markdown
<!-- _header: '' -->

## Special Slide with No Header Bar
```

---

## Customisation patterns

A complete reference for every type of per-deck and per-slide tweak.
All examples assume the full deck template frontmatter above.

---

### Colour palette — recolour the whole deck

Change all 6 tokens together in `:root`. Partial overrides leave mismatched shades.

```yaml
style: |
  :root {
    --primary:        #73216d;   /* CUHK purple */
    --primary-dark:   #5a1957;
    --primary-darker: #3f1240;
    --primary-light:  #dda300;   /* CUHK gold — h2 underline, blockquote border */
    --bg-stripe:      #f4dfb0;   /* light gold — inline code bg */
    --bg-stripe2:     #faf4e8;   /* warm cream — table even rows */
  }
```

See the preset palette table in `beamer-css.md` for CUHK, teal, burgundy, and slate grey.

---

### Font size — deck-wide

```yaml
style: |
  :root {
    --font-size: 20px;   /* default 22px — reduce for dense slides */
  }
```

---

### Definition block width — deck-wide

```yaml
style: |
  :root {
    --defblock-width: 100%;   /* default 88% */
  }
```

### Definition block width — one slide only

Define the class once in the frontmatter `style:` block (already in the template):
```yaml
  section.wide-defblock blockquote:has(> h4) { max-width: 100%; }
```

Apply on the target slide:
```markdown
<!-- _class: wide-defblock -->

> #### Key Finding
> This box stretches full width on this slide only.
```

---

### Table width and font — one slide only

```yaml
  section.wide-table table { max-width: 100%; width: 100%; }
  section.small-table table { font-size: 0.7em; }   /* default 0.82em */
  section.small-text { font-size: 18px; }
```

```markdown
<!-- _class: wide-table small-table -->

## Dense Results Table   ← full-width, smaller font, this slide only

| Col A | Col B | Col C |
|:------|:-----:|------:|
| ...   | ...   | ...   |
```

Multiple classes are **space-separated**. Combine freely:
```markdown
<!-- _class: wide-defblock wide-table -->
```

---

### Inline text: colour and size on specific words

```markdown
The effect <span style="color: #73216d; font-weight: 700;">decays within 2 years</span>
and <span style="font-size: 0.85em; color: #888;">cannot be restored</span> by reinforcement.
```

---

### Images: sizing

```markdown
![w:400](image.png)          <!-- 400px wide, height proportional -->
![w:50%](image.png)          <!-- 50% of slide width -->
![w:300 h:200](image.png)    <!-- fixed width and height -->
![center w:500](image.png)   <!-- centred, 500px -->
```

---

### Images: side-by-side (horizontal row)

Use `<img>` tags inside a flex `<div>` — **not** Markdown `![]()` syntax,
which always renders as a block. The beamer CSS includes `div img { display: inline }`
so no extra per-image style is needed.

```markdown
<div style="display: flex; gap: 1rem; justify-content: center;"><img src="img1.png" width="300"/><img src="img2.png" width="300"/></div>
```

Adjust `gap` for spacing, `justify-content` for alignment (`flex-start`, `center`, `space-between`).
Each `<img>` can have a different `width`.

---

### Centering: text, captions, and tables

The theme provides `.center` (general) and `.caption` (figure label) utilities.

**Center any text or inline content:**
```markdown
<div class="center">Centered text, bold, or any inline content</div>
```

**Figure caption (centered, small, grey):**
```markdown
![center w:500](figure.png)

<div class="caption">Figure 1. Predicted margins by year under surveillance</div>
```

**Center a table** — markdown tables cannot be wrapped in a `<div>`. Use a slide-level
class. Add this to the frontmatter `style:` block:
```yaml
style: |
  section.center-table table { margin: 0.5em auto; }
```
Then on the slide:
```markdown
<!-- _class: center-table -->

## Results

| A | B | C |
|:--|:--|:--|
| 1 | 2 | 3 |
```

All require `"markdown.marp.html": true` in `.vscode/settings.json`.

---

### Images: background split layout

Reserves a portion of the slide for an image; text fills the rest.

```markdown
<!-- header: 'Case Study' -->

## Slide Title

![bg left:40% contain](map.png)

- Bullet point in the right 60%
- Another point
```

Use `left` or `right`; the percentage controls image width. `contain` fits the image inside;
`cover` (default) fills and crops.

---

### Per-slide font size

```yaml
  section.small-text { font-size: 18px; }
  section.large-text { font-size: 26px; }
```

```markdown
<!-- _class: small-text -->

## Dense Slide — everything is 18px on this slide only
```

---

### Line spacing — deck-wide or per-slide

Default `line-height` values in the theme:
- Slide body: `1.5`
- Lists (`ul`, `ol`): `1.8`
- Definition block body: `1.55`

**Deck-wide** (reduce for dense content throughout):
```yaml
style: |
  section { line-height: 1.3; }
  ul, ol  { line-height: 1.5; }
```

**Per-slide only:**
```yaml
style: |
  section.tight { line-height: 1.3; }
  section.tight ul, section.tight ol { line-height: 1.5; }
```
```markdown
<!-- _class: tight -->

## Dense Slide
```

---

### Vertical centering on a non-title slide

By default slides are top-aligned (`justify-content: flex-start`). To vertically
centre content on a specific slide (e.g., a transition/quote slide):

```yaml
style: |
  section.vcenter { justify-content: center; }
```
```markdown
<!-- _class: vcenter -->

## A Centred Transition Slide

> *Key takeaway stated here.*
```

Combine with title layout if needed: `<!-- _class: title vcenter -->` (title gives
horizontal centering; vcenter gives vertical).

---

### Blockquote width — per-slide

`--blockquote-width` (default `90%`) sets deck-wide width. For a wider or full-width
blockquote on one slide only:

```yaml
style: |
  section.wide-quote blockquote { max-width: 100%; }
```
```markdown
<!-- _class: wide-quote -->

> Short pithy quote that benefits from more horizontal space.
```

For a narrower, centred pull-quote feel, reduce and pair with `.center`:
```yaml
  section.pull-quote blockquote { max-width: 60%; margin: 0 auto; }
```

---

### Combining per-slide class with built-in class

`_class` replaces the slide's class — combine with built-ins using spaces:

```markdown
<!-- _class: title wide-defblock -->   ← title layout AND wide definition block
```

---

### What does NOT work — common mistakes

| Attempt | Result | Correct approach |
|:--------|:-------|:-----------------|
| `<!-- _style: 'h2 { color: red }' -->` | Silently ignored — `_style` is not a valid Marp directive | Define `section.myclass h2 { color: red }` in frontmatter, use `<!-- _class: myclass -->` |
| `<!-- _class: myclass -->` with `:root { --defblock-width: 100% }` inside the class rule | No effect — Marp doesn't re-evaluate CSS vars at section scope | Target element directly: `section.myclass blockquote:has(> h4) { max-width: 100% }` |
| `![w:300](a.png) ![w:300](b.png)` on same line | Still stacks vertically — `img { display: block }` in theme CSS | Use `<img>` tags inside a flex `<div>` (see side-by-side pattern above) |

---

## Common footer patterns

```yaml
# Three-section academic footer
footer: '**Dr. Jane Smith** **Surveillance & Compliance** **APSA · Sept 2025**'

# Two meaningful sections + blank third
footer: '**Jane Smith** **University of X** **  **'

# Minimal: just name and date
footer: '**Jane Smith** **  ** **2025**'
```

Each `**…**` segment becomes one footer section (left / centre / right).

---

## Appendix navigation — clickable TOC with back buttons

For presentations with appendix slides (Q&A backup material), use Marp's native
numeric slide IDs (`#N`) for all inter-slide links. This is the only reliable
mechanism — custom `_id` directives are silently ignored by Marp.

### How it works

- Marp assigns every slide a numeric anchor `#1`, `#2`, … in the exported HTML.
- Links like `[text](#N)` in the HTML export are clickable and jump correctly.
- Count slide numbers manually (every `---` separator starts a new slide).
- Title/thank-you slides with `<!-- _paginate: skip -->` still consume a number
  in the HTML — skip does not affect anchor numbering, only the visible counter.

### Step 1 — TOC slide (insert after your closing/thank-you slide)

```markdown
---
<!-- _paginate: skip -->
<!-- _header: 'Appendix: Contents' -->

## Appendix: Contents

**Measurement:** [IV — Treatment Variable](#15) · [DV — Outcome Variable](#19)

**Results:** [CGSS2006](#22) · [CGSS2010](#24) · [Pooled Analysis](#26)

**Robustness:** [PSM (I)](#33) · [Reverse Causality (II)](#35) · [City Tracing (III)](#36) · [Spatial Lag (IV)](#38)

**Teaching:** [UG Course](#44) · [PG Course](#45) · [AI Policy](#47)
```

Group entries by category using `**Category:**` bold labels. Use `·` as separator.

### Step 2 — Back button on the last slide of each section

Place this HTML on the **last** slide of each appendix section (not the first):

```html
<a href="#14" style="position:absolute; bottom:1.8rem; left:1.5rem; font-size:0.85em; color:var(--primary); text-decoration:none; background:rgba(244,223,176,0.9); padding:0.15em 0.45em; border-radius:0.25em;">↩</a>
```

Replace `#14` with the actual slide number of your TOC slide. The button sits in
the bottom-left corner using `position:absolute`, safely outside the content flow.

Use `↩` (U+21A9) as the icon — clean, universally supported, no emoji needed.

### Step 3 — Appendix slides use `_paginate: skip`

All appendix slides should suppress page numbers:

```markdown
---
<!-- _paginate: skip -->
<!-- header: 'Appendix: Section Name' -->

## Slide Title
```

### Worked example — two-section appendix

```markdown
<!-- TOC slide — say it's slide 14 -->
---
<!-- _paginate: skip -->
<!-- _header: 'Appendix: Contents' -->

## Appendix: Contents

**Section A:** [Measurement](#15) · [Results](#17)
**Section B:** [Robustness Check](#19)

<!-- Last slide of Section A — slide 16 -->
---
<!-- _paginate: skip -->
<!-- header: 'Appendix: Section A' -->

## Results Figure

![center w:700](figures/result.png)

<a href="#14" style="position:absolute; bottom:1.8rem; left:1.5rem; font-size:0.85em; color:var(--primary); text-decoration:none; background:rgba(244,223,176,0.9); padding:0.15em 0.45em; border-radius:0.25em;">↩</a>

<!-- Last slide of Section B — slide 20 -->
---
<!-- _paginate: skip -->
<!-- header: 'Appendix: Section B' -->

## Robustness Table

![center w:700](figures/robustness.png)

<a href="#14" style="position:absolute; bottom:1.8rem; left:1.5rem; font-size:0.85em; color:var(--primary); text-decoration:none; background:rgba(244,223,176,0.9); padding:0.15em 0.45em; border-radius:0.25em;">↩</a>
```

### Key rules

| Rule | Reason |
|:-----|:-------|
| Use `#N` numeric anchors only | `<!-- _id: name -->` is not a valid Marp directive and is silently ignored |
| Put back button on the **last** slide of each section | First-slide placement is confusing — you haven't seen the content yet |
| Keep TOC slide number stable | Adding/removing slides before the appendix shifts all numbers — recount after any structural change |
| `_paginate: skip` does not shift numbering | The slide still gets an HTML anchor; it just hides the visible page counter |
| Export as HTML for navigation | PDF does not support inter-slide hyperlinks; HTML export (`.html`) does |

### Presenter mode in HTML export

Export → HTML from VS Code Marp extension, open in browser, press **`P`** for
presenter view. Navigation links work in both presenter and normal view.
