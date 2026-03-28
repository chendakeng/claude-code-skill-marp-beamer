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
    --primary-light:  #9999dd;   /* minor accents */
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
